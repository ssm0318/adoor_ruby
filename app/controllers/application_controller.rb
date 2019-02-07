class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :noties
  helper_method :recent_noties

  # acts_as_token_authentication_handler_for User, fallback: :none # handles header authorization
  # for future reference: https://github.com/gonzalo-bulnes/simple_token_authentication include token in the header

  alias_method :devise_current_user, :current_user
  def current_user
    if request.path_parameters[:format] == 'json'
      @current_user ||= User.find(payload['user_id'])
    else
      devise_current_user
    end
  end

  def unread
    arr = []
    if !current_user.nil?
      unread_notifications = current_user.notifications.where(read_at: nil)
      unread_notifications.each do |noti|
        arr.push(noti.id)
      end
      render json: {
        name: current_user.username,
        id: arr
      }
    else
      render json: {
        name: "akdfasldksladlsakvlsfjaoifnowknalkvnkvdowisvdknlweoifjwe",
        id: arr
      }
    end
  end

  def noties
    if user_signed_in?
      Notification.where(recipient_id: current_user.id).visible.order(updated_at: :desc)
    end
  end

  def recent_noties
    if user_signed_in?
      Notification.where(recipient_id:current_user.id).visible.order(updated_at: :desc).limit(20)
    end
  end

  def intro
    render './intro'
  end
 
  protected
 
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username])
  end

  private

  def retrieve_token
    request.headers['Authorization'].split(' ').last
  end

  def payload
    JWT.decode retrieve_token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' }.first
  end
end

