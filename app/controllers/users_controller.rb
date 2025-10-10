class UsersController < ApplicationController
  def create
    @current_user = User.create!(user_params)
  end

  def edit
  end

  def destroy
    User.find(user_params[:id]).destroy!
    redirect_to rooms_path, notice: "Profile successfully deleted"
  end

  private

  def user_params
    params.require(:user).permit(:id, :name)
  end
end
