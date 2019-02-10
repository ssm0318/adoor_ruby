class AnswersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_answer, only: [:show, :edit, :update, :destroy]
    before_action :check_mine, only: [:edit, :update, :destroy]
    before_action :check_accessibility, only: [:show]

    def new
        unless ajax_request?
            redirect_to root_url
        else
            @question = Question.find(params[:id])
            @answer = Answer.new

            html_content = render_to_string :partial => 'answers/form', :locals => { :answer => @answer, :@question => @question }
            render :json => { 
                html_content: "#{html_content}",
            }
        end
    end
    
    def create 
        @answer = Answer.new(answer_params)
        @answer.save

        channels = []   # 선택된 채널들을 갖고 있다.
        channels = Channel.find(params[:c]) if params[:c]
        channels.each do |c|
            Entrance.create(channel: c, target: @answer)
        end

        # assign 당한 유저C가 해당 질문에 대해 답하면 그 질문에 대해 유저C를 assign한 모든 유저들에게 보내지는 노티 생성.
        assignment_hash = { target: @answer.question, assignee_id: @answer.author_id }
        Assignment.where(assignment_hash).find_each do |assignment|
            # 답변의 공개그룹에 assigner가 포함되어있는 경우에만 노티가 감.
            if !(channels & assignment.assigner.belonging_channels).empty?
                Notification.create(recipient: assignment.assigner, actor: @answer.author, target: @answer, origin: @answer, action: 'assignment-answer')
            end
        end

        if params[:from_feed]
            redirect_to question_path(@answer.question)
        elsif params[:from_noti]
            redirect_to answer_path(@answer)
        else
            render :json => {

            }
        end
    end

    def show
        @anonymous = @answer.author_id != current_user.id && !(current_user.friends.include? @answer.author)
    end

    def edit 
        unless ajax_request?
            redirect_to root_url
        else
        html_content = render_to_string :partial => 'answers/form', :locals => { :answer => @answer, :@question => @answer.question }
        render :json => { 
            html_content: "#{html_content}",
        }
        end
    end

    def update
        if @answer.update(answer_params)

            original_channels = @answer.channels
            selected_channels = []
            selected_channels = Channel.find(params[:c]) if params[:c]
            # 안겹치는 애들만 모아다가
            changed_channels = selected_channels - original_channels
            changed_channels += original_channels - selected_channels
            # 바꿔줍니다
            changed_channels.each do |c|
                e = Entrance.find_or_initialize_by(channel: c, target: @answer)
                e.persisted? ? e.destroy : e.save
            end

            ################################## 테스팅 완료
            # 공개 범위의 변화로 인해 못 보게 된 글 / 댓글에 대한 노티를 모두 삭제한다
            ## 친구공개였다가 아니게 된 것 : 거기 댓글 / 대댓글 단 친구들에게 간 노티 다 없어짐
            ## 익명피드 공개였다가 아니게 된 것 : 거기 댓글 / 대댓글 단 사람들한테 간 노티 다 없어짐
            # visible이고 아니고 다 지우는 걸로 일단 했다
            ## 즉, 범위를 두 번 바꾼다고 해서 예전 노티가 다시 살아나진 않음
            comment_join = "INNER JOIN comments ON notifications.origin_id = comments.id AND notifications.origin_type = 'Comment'"
            reply_join = "INNER JOIN replies ON notifications.origin_id = replies.id AND notifications.origin_type = 'Reply'"

            friend_noties = []
            friend_noties += Notification.where(target_type: 'Like', action: 'friend_like_comment').joins(comment_join).merge(Comment.where(target: @answer)).distinct
            friend_noties += Notification.where(target_type: 'Like', action: 'friend_like_reply').joins(reply_join).merge(Reply.joins(:comment).where(comments: {target: @answer})).distinct
            friend_noties += Notification.where(target_type: 'Reply', action: 'friend_to_comment').joins(comment_join).merge(Comment.where(target: @answer)).distinct
            friend_noties += Notification.where(target_type: 'Reply', action: 'friend_to_recomment').joins(comment_join).merge(Comment.where(target: @answer)).distinct
            friend_noties += Notification.where(target: @answer, action: 'assignment-answer')

            friend_noties.each do |n|
                if (n.recipient != @answer.author) && (n.recipient.belonging_channels & selected_channels).empty?
                    n.destroy
                end
            end
            
            if original_channels.any?{|c| c.name == '익명피드'} && !selected_channels.any?{|c| c.name == '익명피드'}  # 원래 익명피드 공개였는데 바뀐 경우에만
                anonymous_noties = []
                anonymous_noties += Notification.where(target_type: 'Like', action: 'anonymous_like_comment').joins(comment_join).merge(Comment.where(target: @answer)).distinct
                anonymous_noties += Notification.where(target_type: 'Like', action: 'anonymous_like_reply').joins(reply_join).merge(Reply.joins(:comment).where(comments: {target: @answer})).distinct
                anonymous_noties += Notification.where(target_type: 'Reply', action: 'anonymous_to_comment').joins(comment_join).merge(Comment.where(target: @answer)).distinct
                anonymous_noties.each do |n|
                    if n.recipient != @answer.author
                        n.destroy
                    end
                end
            end
            ########################################

            channel_names = ""
            selected_channels.each do |c|
                if c.id != selected_channels.last.id
                    channel_names += c.name + " | "
                else
                    channel_names += c.name
                end
            end
            
            render :json => {
                id: @answer.id,
                channels: channel_names,
                type: "answer-feed"
            }
        else
            redirect_to root_url
        end
    end

    def destroy
        @answer.destroy 
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

        def check_accessibility
            author =  Answer.find(params[:id]).author
            if (author.friends.include? current_user) && author != current_user && !Answer.accessible(current_user.id).exists?(params[:id])
                redirect_to root_url
            elsif !(author.friends.include? current_user) && author != current_user && !Answer.find(params[:id]).channels.any?{|c| c.name == '익명피드'}
                redirect_to root_url
            end
        end

        def ajax_request?
            (defined? request) && request.xhr?
        end
end
