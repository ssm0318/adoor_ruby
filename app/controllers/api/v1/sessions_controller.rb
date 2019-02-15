class Api::V1::SessionsController < ApplicationController
  # HMAC_SECRET = Rails.application.secrets.secret_key_base

  # page가 reload할 때마다 token이 valid한지 확인하는 것.
  def show
    current_user ? head(:ok) : head(:unauthorized)
  end

  def create
    @user = User.where(email: params[:email]).first

    if @user && @user.valid_password?(params[:password])
      # jwt = JWT.encode(
      #   { user_id: @user.id, exp: (Time.now + 2.weeks).to_i },
      #   HMAC_SECRET,
      #   'HS256'
      # )
      # render :create, locals: { token: jwt }, status: :created # refer to views/api/v1/sessions/create.json.jbuilder

      jwt = WebToken.encode(@user)
      render :create, status: :created, locals: { token: jwt }
    else
      # head(:unauthorized)
      render json: { status: 'invalid_credentials', message: 'Sign in unsuccessful', data: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    # 현재 session에서의 token을 더 이상 사용할 수 없게 함.
    current_user && current_user.authentication_token = nil
    if current_user&.save
      render json: { status: 'SUCCESS', message: 'Successfully signed out' }, status: :ok
    else
      render json: { status: 'ERROR', message: 'Sign out unsuccessful', data: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
