class CommentsController < ApplicationController
    def create
        if params[:secret].nil?
            secret = false
        else
            secret = params[:secret]
        end
        c = Comment.create(content: params[:content], author_id: current_user.id, target_type: params[:target_type], target_id: params[:target_id], anonymous: params[:anonymous], secret: secret)

        if c.anonymous
            html_content = render_to_string :partial => 'comments/general_ajax', :locals => { :feed => @answer, :c => c }
        else
            html_content = render_to_string :partial => 'comments/friends_ajax', :locals => { :feed => @answer, :c => c }
        end

        render json: {
            html_content: html_content
        }
        
    end

    def destroy
        c = Comment.find(params[:id])
        c.destroy

        render json: {
            
        }
    end
end
