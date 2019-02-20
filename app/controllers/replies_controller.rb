class RepliesController < ApplicationController
    before_action :set_reply, only: [:destroy]
    before_action :check_confirmation, only: [:create]

    def create
        secret = params[:secret].nil? ? false : params[:secret]
        r = Reply.create(content: params[:content], author_id: current_user.id, comment_id: params[:id], secret: secret, anonymous: params[:anonymous], target_author_id: params[:target_author_id])


        if r.anonymous
            html_content = render_to_string :partial => 'replies/general_ajax', :locals => { :r => r, :comment_available => false}
        else
            html_content = render_to_string :partial => 'replies/friends', :locals => { :r => r, :comment_available => true}
        end

        render json: {
            html_content: html_content
        }
    end

    def destroy
        @reply.destroy

        render json: {

        }
    end

    private
        def set_reply
            @reply = Reply.find(params[:id])
        end

        def check_confirmation
            if current_user.confirmed_at.nil? && Identity.where(user_id: current_user.id).empty?
                redirect_to require_confirmation_url
            end
        end
end
