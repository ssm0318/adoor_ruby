class AnswersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_answer, only: [:show, :edit, :update, :destroy]
    before_action :check_mine, only: [:edit, :update, :destroy]
    before_action :check_friends, only: [:show]

    def new
        @question = Question.find(params[:id])
        @answer = Answer.new
        render 'new'
    end
    
    def create 
        @answer = Answer.new(answer_params)
        @answer.save

        if !@answer.tag_string.nil?
            tag_array = @answer.tag_string.gsub("\r\n", '\n').split('\n')
            tag_array.each do |tag|
                new_tag = Tag.create(author_id: @answer.author.id, content: tag, target: @answer)
                @answer.tags << new_tag
            end
        end
       
        redirect_to root_path
    end

    def show 
    end

    def edit
        @question = @answer.question
    end

    def update
        if @answer.update(answer_params)
            @answer.tags.destroy_all

            if !@answer.tag_string.nil?
                tag_array = @answer.tag_string.gsub("\r\n", "\n").split("\n") 
                tag_array.each do |tag|
                    new_tag = Tag.create(author_id: @answer.author.id, content: tag, target: @answer)
                    @answer.tags << Tag.find(new_tag.id)
                end
            end

            redirect_to @answer
        else
            render 'edit'
        end
    end

    def destroy
        @answer.destroy 

        redirect_to user_answers_path(current_user.id)
    end

    def user_answers
        @user = User.find(params[:id])
        @answers = @user.answers
    end

    def general_feed
        @answers = Answer.anonymous(current_user.id)
        render 'general_feed'
    end

    def friend_feed
        @answers = Answer.not_anonymous(current_user.id)
        render 'friend_feed'
    end

    def question_feed_friend
        @question = Question.find(params[:id])
        @answers = @question.answers.not_anonymous(current_user.id)
        render 'question_feed_friend'
    end

    def question_feed_general
        @question = Question.find(params[:id])
        @answers = @question.answers.anonymous(current_user.id)
        render 'question_feed_general'
    end

    def create_comment
        id = params[:recipient_id]
        if id == '0'
            c = Comment.create(content: params[:content], author_id: current_user.id, target: Answer.find(params[:id]))
            # render json: {
            #     comment_id: c.id,
            #     imageurl: current_user.image.url,
            #     path: user_answers_path(current_user.id),
            #     username: current_user.username,
            #     content: params[:content],
            #     like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
            #     like_changed_url: like_path(c.id, target_type: 'Comment'),
            # }

            render json: {
                content: c.content,
                comment_id: c.id,
                created_at: c.created_at,
                like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
                like_changed_url: like_path(c.id, target_type: 'Comment'),
            }
        else
            c = Comment.create(content: params[:content], author_id: current_user.id, recipient_id: params[:recipient_id], target: Answer.find(params[:id]))
            # render json: {
            #     imageurl: current_user.image.url,
            #     path: user_answers_path(current_user.id),
            #     username: current_user.username,
            #     content: params[:content],
            #     like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
            #     like_changed_url: like_path(c.id, target_type: 'Comment'),
            # }
            render json: {
                content: c.content,
                created_at: c.created_at,
                like_url: likes_path(target_id: c.id, target_type: 'Comment'), 
                like_changed_url: like_path(c.id, target_type: 'Comment'),
            }
        end
            
        # answer_author_id = Answer.find(params[:id]).author_id
        # redirect_back fallback_location: user_answers_path(answer_author_id)

        # html_content: "<img src='#{current_user.image.url}' alt='' style='height:20px; width:20px; border-radius:10px; margin-right: 2px;'><a href='#{user_answers_path(current_user.id)}' class='username'>#{current_user.username}</a><span style='vertical-align: +6px;'>: #{params[:content]} <br/></span>"
    end

    def create_reply
        r = Reply.create(content: params[:content], author_id: current_user.id, comment_id: params[:id])
        answer_author_id = r.comment.target.author_id
        
        # redirect_back fallback_location: user_answers_path(answer_author_id)

        # render json: {
        #     imageurl: current_user.image.url,
        #     path: user_answers_path(current_user.id),
        #     username: current_user.username,
        #     content: params[:content],
            # like_url: likes_path(target_id: r.id, target_type: 'Reply'), 
            # like_changed_url: like_path(r.id, target_type: 'Reply'),
        # }

        render json: {
            content: r.content,
            created_at: r.created_at,
            like_url: likes_path(target_id: r.id, target_type: 'Reply'), 
            like_changed_url: like_path(r.id, target_type: 'Reply'),
        }
    end

    private
        def set_answer
            @answer = Answer.find(params[:id])
        end

        def answer_params
            params.require(:answer).permit(:author_id, :question_id, :content, :tag_string)
        end 

        def check_mine
            if @answer.author_id != current_user.id
                redirect_to root_url
            end
        end

        def check_friends
            if @answer.author.friends.where(id: current_user.id).empty?
                redirect_to root_url
            end
        end
end
