class CommentsController < ApplicationController
    def create
        Comment.create(content: params[:content], author_id: current_user.id, recipient_id: params[:recipient_id], target: Answer.find(params[:id]))
        answer_author_id = Answer.find(params[:id]).author_id
        redirect_back fallback_location: user_answers_path(answer_author_id)
    end

    def destroy
        c = Comment.find(id: params[:id])
        target = c.target
        c.destroy

        
    end
end
 