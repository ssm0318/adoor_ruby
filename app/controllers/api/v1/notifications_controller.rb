class Api::V1::NotificationsController < ApplicationController
  # before_action :authenticate_user!

  def index
    @notifications = Notification.all
  end

  def read_all
    Notification.where(recipient_id: current_user.id).unread.each do |n|
      n.read_at = DateTime.now
      n.save(touch: false)
    end
    # redirect_back(fallback_location: root_path)
    # redirect_to request.referrer
  end

  def read
    noti = Notification.find(params[:id])

    if noti.recipient_id != current_user.id
      render json: {status: 'ERROR', message:'not accessible', data: current_user}, status: :unauthorized
    else
      if noti.read_at.nil?
        noti.read_at = DateTime.now
        noti.save(touch: false) # updated_at을 update하지 않기 위해!!
      end

      render :read, { notification: noti }
    end
  end

  # private

  # def authenticate_user
  #   user_token = request.headers['X-USER-TOKEN']
  #   if user_token
  #     @user = User.find_by_token(user_token)
  #     #Unauthorize if a user object is not returned
  #     if @user.nil?
  #       return unauthorize
  #     end
  #   else
  #     return unauthorize
  #   end
  # end

  # def unauthorize
  #   head status: :unauthorized
  #   return false
  # end
end
