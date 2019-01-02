# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # 이 부분 직접 api 보면서 수정하면 로그인 페이지로 리다이렉트되는거 수정할수있음
  # https://github.com/plataformatec/devise#configuring-controllers
  # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/passwords_controller.rb
  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
