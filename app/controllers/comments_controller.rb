class CommentsController < ApplicationController
    def create
        # Comment.create(content: params[:content], author_id: current_user.id, recipient_id: params[:recipient_id], answer_id: params[:answer_id])
        
        redirect_back fallback_location: user_stars_path(current_user.id)

    end
end
