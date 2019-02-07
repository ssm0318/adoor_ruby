class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render :create
    else
      head(:unprocessible_entity)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :passwrod, :password_confirmation)
  end
end
