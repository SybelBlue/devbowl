class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:room_id])
    stream_for room

    # Add user to room if they're not already there
    current_user.update(room: room) if current_user.room != room

    # Broadcast that someone joined
    broadcast_to room, {
      type: 'user_joined',
      user: current_user.name,
      users_count: room.users.count
    }
  end

  def unsubscribed
    # Remove user from room
    current_user&.update(room: nil)
  end

  def get_current_state
    room = Room.find(params[:room_id])
    game = room.current_game

    if game&.current_question
      broadcast_to room, {
        type: 'question_started',
        question: {
          id: game.current_question.id,
          title: game.current_question.title,
          toss_up: game.current_question.toss_up&.content,
          format: game.current_question.toss_up&.format
        }
      }
    end
  end

  def buzz_in(data)
    room = Room.find(params[:room_id])
    game = room.current_game

    return unless game&.reading?

    # Create the buzz
    buzz = game.buzzes.create!(
      user: current_user,
      question: game.current_question,
      timestamp: Time.current
    )

    # Pause the game
    game.update!(status: 'paused')

    # Broadcast to everyone that someone buzzed
    broadcast_to room, {
      type: 'buzz_received',
      user: current_user.name,
      buzz_id: buzz.id,
      game_status: 'paused'
    }
  end

  def submit_answer(data)
    room = Room.find(params[:room_id])
    game = room.current_game
    buzz = game.buzzes.find(data['buzz_id'])

    return unless buzz.user == current_user

    buzz.update!(answer: data['answer'])

    # Here you'd implement answer checking logic
    # For now, let's assume all answers are correct
    buzz.update!(correct: true)

    # Resume or advance the game
    game.update!(status: 'reading')

    broadcast_to room, {
      type: 'answer_submitted',
      user: current_user.name,
      answer: buzz.answer,
      correct: buzz.correct,
      game_status: 'reading'
    }
  end
end
