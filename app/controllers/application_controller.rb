class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :noties

  def noties
    if user_signed_in?
      @noties = Notification.where(recipient_id: current_user.id).order(updated_at: :desc)
    end
  end

  # in order to override the default behavior of devise 
  # def after_sign_in_path_for(resource)
  #   current_user_path
  # end
 
  protected
 
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username])
  end
end

