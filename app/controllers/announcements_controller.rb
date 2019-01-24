class AnnouncementsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin, except: [:index]
    before_action :set_announcement, only: [:publish, :unpublish, :destroy]

    def index 
        @published_announcements = Announcement.published.sort_by(&:published_at).reverse!
        render 'index'
    end

    def admin_index
        @published_announcements = Announcement.published.sort_by(&:published_at).reverse!
        @unpublished_announcements = Announcement.unpublished.sort_by(&:created_at).reverse!

        render 'admin_index'
    end

    def create
        Announcement.create(content: params[:content], title: params[:title])
        redirect_to announcement_admin_index_path
    end

    def publish
        if @announcement.published_at == nil
            @announcement.published_at = DateTime.now()
            @announcement.save(touch: false)  # updated_at을 update하지 않기 위해!!
        end

        User.all.each do |u|
            Notification.create(recipient: u, actor: User.find(1), target: @announcement, origin: @announcement)
        end

        redirect_to announcement_admin_index_path
    end

    def destroy
        @announcement.destroy 

        redirect_to announcement_admin_index_path
    end

    private
    def check_admin
        if !current_user.has_role? :admin
            redirect_to root_url
        end
    end

    def set_announcement
        @announcement = Announcement.find(params[:id])
    end
end
