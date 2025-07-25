class QuestionsController < ApplicationController
  before_action :set_question, only: [ :show, :edit, :update, :destroy ]

  def index
    @questions = Question.includes(:toss_up, :bonus).all
  end

  def show
  end

  def new
    @question = Question.new
    @question.prompts.build(type: "TossUp")
    @question.prompts.build(type: "Bonus")
  end

  def edit
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: "Question was successfully created."
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: "Question was successfully updated."
    else
      render :edit, status: 422, alert: "Question failed to update"
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_url, notice: "Question was successfully deleted."
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      prompts_attributes: [
        :id,
        :type,
        :content,
        :format,
        :answer,
        { answer_choices: [] },
        :_destroy
      ]
    )
  end
end
