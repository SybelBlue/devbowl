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

    @current_game = @room.current_game
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

    # End any existing games first
    @room.games.where(status: [ "reading", "paused" ]).update_all(status: "completed")

    # Create a new game with the first question
    first_question = Question.first

    unless first_question
      redirect_to @room, alert: "No questions available. Please add some questions first."
      return
    end

    _game = @room.games.create!(
      status: "reading",
      current_question: first_question
    )

    redirect_to @room
  end

  def next_question
    @room = Room.find(params[:id])
    game = @room.current_game

    unless game
      redirect_to @room, alert: "No active game found. Please start a game first."
      return
    end

    # For now, just get the next question
    current_id = game.current_question&.id || 0
    next_question = Question.where("id > ?", current_id).first

    if next_question
      game.update!(current_question: next_question, status: "reading")
      redirect_to @room, notice: "Next question loaded!"
    else
      redirect_to @room, alert: "No more questions available!"
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end
