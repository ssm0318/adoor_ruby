class Api::V1::SessionsController < ApplicationController
    # page가 reload할 때마다 token이 valid한지 확인하는 것.
    def show
        current_user ? head(:ok) : head(:unauthorized)
    end

    def create
        @user = User.where(email: params[:email]).first

        if @user && @user.valid_password?(params[:password]) 
            jwt = JWT.encode(
                { user_id: @user.id, exp: (Time.now + 2.weeks).to_i },
                Rails.application.secrets.secret_key_base,
                'HS256'
            )
            render :create, locals: { token: jwt }, status: :created # refer to views/api/v1/sessions/create.json.jbuilder
        else
            head(:unauthorized)
        end
    end

    def destroy
        # 현재 session에서의 token을 더 이상 사용할 수 없게 함.
        if nilify_token && current_user.save
            head(:ok)
        else
            head(:unauthorized)
        end
    end
 
    private

    def nilify_token_and_save
        current_user && current_user.authentication_token == nil
    end
end