class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :noties

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
      @noties = Notification.where(recipient_id: current_user.id).visible.order(updated_at: :desc)
    end
  end

  def intro
    render './intro'
  end
 
  protected
 
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username])
  end
end

