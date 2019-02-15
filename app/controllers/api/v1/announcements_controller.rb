class Api::V1::AnnouncementsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, except: [:index]
  before_action :set_announcement, only: %i[publish unpublish noti destroy]

  def index
    @published_announcements = Announcement.published.sort_by(&:published_at).reverse!

    render :index, locals: { published_announcements: @published_announcements }
  end

  def admin_index
    @published_announcements = Announcement.published.sort_by(&:published_at).reverse!
    @unpublished_announcements = Announcement.unpublished.sort_by(&:created_at).reverse!
  end

  def create
    if @announcement = Announcement.create(content: params[:content], title: params[:title])
      render json: {status: 'SUCCESS', message:'Created announcement', data: @announcement}, status: :ok
    else
      render json: {status: 'ERROR', message:'Announcement not created', data: @announcement.errors.full_messages}, status: :unprocessable_entity
    end
    # redirect_to api_v1_announcement_admin_index_path
  end

  def publish
    if @announcement.published_at.nil?
      @announcement.published_at = DateTime.now
      @announcement.save(touch: false) # updated_at을 update하지 않기 위해!!
    end

    User.all.each do |u|
      Notification.create(recipient: u, actor: User.find(1), target: @announcement, origin: @announcement, action: 'announcement')
    end

    render :publish, locals: { announcement: @announcement }
    # redirect_to api_v1_announcement_admin_index_path
  end

  def noti
    User.all.each do |u|
      Notification.create(recipient: u, actor: User.find(1), target: @announcement, origin: @announcement, action: 're_announcement')
    end

    # redirect_to api_v1_announcement_admin_index_path
  end

  def destroy
    if @announcement.destroy
      render json: {status: 'SUCCESS', message:'Deleted announcement'},status: :ok
    else
      render json: {status: 'ERROR', message:'Announcement not deleted', data: @announcement.errors.full_messages}, status: :unprocessable_entity
    end

    # redirect_to api_v1_announcement_admin_index_path
  end

  private

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

  def check_admin
    # redirect_to root_url unless current_user.has_role? :admin
    if !current_user.has_role? :admin
      render json: {status: 'ERROR', message:'user not admin', data: current_user}, status: :unauthorized
    # else
    #   render json: {status: 'SUCCESS', message:'user is admin', data: current_user}, status: :ok
    end
  end

  def set_announcement
    @announcement = Announcement.find(params[:id])
  end
end
