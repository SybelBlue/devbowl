class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])

    # If no current user, show a simple name form right on the room page
    unless current_user
      @user = User.new
    end
  end

  def join
    @room = Room.find(params[:id])
    user = User.create!(name: params[:name], room: @room)
    session[:user_id] = user.id

    redirect_to @room
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to @room
    else
      render :new
    end
  end

  def start_game
    @room = Room.find(params[:id])

    # Create a new game with the first question
    first_question = Question.first
    game = @room.games.create!(
      status: 'reading',
      current_question: first_question
    )

    # Broadcast the question to everyone
    ActionCable.server.broadcast_to @room, {
      type: 'question_started',
      question: {
        id: first_question.id,
        title: first_question.title,
        toss_up: first_question.toss_up&.content,
        format: first_question.toss_up&.format
      }
    }

    redirect_to @room
  end

  def next_question
    @room = Room.find(params[:id])
    game = @room.current_game

    # For now, just get the next question (you'll want better logic later)
    current_id = game.current_question&.id || 0
    next_question = Question.where('id > ?', current_id).first

    if next_question
      game.update!(current_question: next_question, status: 'reading')

      ActionCable.server.broadcast_to @room, {
        type: 'question_started',
        question: {
          id: next_question.id,
          title: next_question.title,
          toss_up: next_question.toss_up&.content,
          format: next_question.toss_up&.format
        }
      }
    end

    redirect_to @room
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end