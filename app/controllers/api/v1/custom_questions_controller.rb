class Api::V1::CustomQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_custom_question, only: %i[show destroy edit update repost_new friend_comments general_comments likes]
  before_action :check_mine, only: %i[destroy edit update]
  before_action :check_accessibility, only: [:show]

  def create
    @custom_question = CustomQuestion.create(custom_question_params)

    unless @custom_question.tag_string.nil?
      tag_array = @custom_question.tag_string.gsub("\r\n", '\n').split('\n')
      tag_array.each do |tag|
        new_tag = Tag.create(author_id: @custom_question.author.id, content: tag, target: @custom_question)
        @custom_question.tags << new_tag
      end
    end

    channels = [] # 선택된 채널들을 갖고 있다.
    channels = Channel.find(params[:c]) if params[:c]
    channels.each do |c|
      Entrance.create(channel: c, target: @custom_question)
    end

    render json: @custom_question, channels: channels, serializer: CustomQuestionShowSerializer

    # render :custom_question, locals: { custom_question: @custom_question }
  end

  def show
    @anonymous = (@custom_question.author_id != current_user.id) && !(current_user.friends.include? @custom_question.author)

    # render :show, locals: { anonymous: @anonymous, custom_question: @custom_question }
    if @anonymous
      @comments = @custom_question.comments.where(anonymous: true).sort_by(&:created_at)
    else
      @comments = @custom_question.comments.where(anonymous: false).sort_by(&:created_at)
    end
    
    @comments = @comments.paginate(:page => params[:page], :per_page => 5, :param_name => :comment_page)
 
    render json: @custom_question, anonymous: @anonymous, comments: @comments, serializer: CustomQuestionShowSerializer
  end

  def destroy
    # 창조자이며, 누군가가 repost한 사람이 있는 경우
    if !CustomQuestion.where(ancestor_id: params[:id]).empty?
      Notification.where(origin: @custom_question, action: 'repost', recipient_id: @custom_question.author_id).destroy_all
      # 실제로는 삭제되지 않고 author가 admin으로 바뀐다. (얘네를 repost한 애들이 있다면 ancestor_id를 그대로 유지해야 하기 때문)
      @custom_question.author_id = 1
      @custom_question.save

      # render :custom_question, locals: { custom_question: @custom_question }
    # 창조자이지만 repost한 사람이 없거나, 창조자가 아닌 경우
    else
      if @custom_question.destroy
        render json: {status: 'SUCCESS', message:'Deleted custom question'},status: :ok
      else
        render json: {status: 'ERROR', message:'custom question not deleted', data: @custom_question.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end

  # custom question repost new
  # custom question을 repost했을 때 새로운 custom_question 만들기
  def repost_new
    # render :repost
    render json: @custom_question, serializer: CustomQuestionFormSerializer
  end

  # custom question repost create
  def repost_create
    ancestor = CustomQuestion.find(params[:id])
    @custom_question = CustomQuestion.create(author_id: current_user.id, content: ancestor.content, repost_message: params[:repost_message], ancestor_id: ancestor.id)
    ancestor.tags.each do |t|
      new_tag = Tag.create(author_id: current_user.id, content: t.content, target: @custom_question)
      @custom_question.tags << new_tag
    end
    channels = [] # 선택된 채널들을 갖고 있다.
    channels = Channel.find(params[:c]) if params[:c]
    channels.each do |c|
      Entrance.create(channel: c, target: @custom_question)
    end

    # assign 당한 유저C가 해당 질문에 대해 답하면 그 질문에 대해 유저C를 assign한 모든 유저들에게 보내지는 노티 생성.
    assignment_hash = { target: ancestor, assignee_id: current_user }
    Assignment.where(assignment_hash).find_each do |assignment|
        # 답변의 공개그룹에 assigner가 포함되어있는 경우에만 노티가 감.
        if !(channels & assignment.assigner.belonging_channels).empty?
            Notification.create(recipient: assignment.assigner, actor: current_user, target: @custom_question, origin: @custom_question, action: 'custom-assignment-answer')
        end
    end

    render json: @custom_question, channels: channels, serializer: CustomQuestionShowSerializer
    # render :custom_question, locals: { custom_question: @custom_question }
  end

  # custom question repost message edit
  def edit
    @reposting = false

    @channel_names = []
    @custom_question.channels.each do |c|
      @channel_names.push(c.name)
    end

    render json: @custom_question, reposting: @reposting, channels: @channel_names, serializer: CustomQuestionFormSerializer
    
    # render :repost, locals: { custom_question: @custom_question, reposting: @reposting }
  end

  def update
    if @custom_question.update(custom_question_params)

      original_channels = @custom_question.channels
      selected_channels = []
      selected_channels = Channel.find(params[:c]) if params[:c]
      # 안겹치는 애들만 모아다가
      changed_channels = selected_channels - original_channels
      changed_channels += original_channels - selected_channels
      # 바꿔줍니다
      changed_channels.each do |c|
        e = Entrance.find_or_initialize_by(channel: c, target: @custom_question)
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
      friend_noties += Notification.where(target_type: 'Like', action: 'friend_like_comment').joins(comment_join).merge(Comment.where(target: @custom_question)).distinct
      friend_noties += Notification.where(target_type: 'Like', action: 'friend_like_reply').joins(reply_join).merge(Reply.joins(:comment).where(comments: { target: @custom_question })).distinct
      friend_noties += Notification.where(target_type: 'Reply', action: 'friend_to_comment').joins(comment_join).merge(Comment.where(target: @custom_question)).distinct
      friend_noties += Notification.where(target_type: 'Reply', action: 'friend_to_recomment').joins(comment_join).merge(Comment.where(target: @custom_question)).distinct

      friend_noties.each do |n|
        if (n.recipient != @custom_question.author) && (n.recipient.belonging_channels & selected_channels).empty?
          n.destroy
        end
      end

      if (original_channels.any? { |c| c.name == '익명피드' }) && (selected_channels.none? { |c| c.name == '익명피드' }) # 원래 익명피드 공개였는데 바뀐 경우에만
        anonymous_noties = []
        anonymous_noties += Notification.where(target_type: 'Like', action: 'anonymous_like_comment').joins(comment_join).merge(Comment.where(target: @custom_question)).distinct
        anonymous_noties += Notification.where(target_type: 'Like', action: 'anonymous_like_reply').joins(reply_join).merge(Reply.joins(:comment).where(comments: { target: @custom_question })).distinct
        anonymous_noties += Notification.where(target_type: 'Reply', action: 'anonymous_to_comment').joins(comment_join).merge(Comment.where(target: @custom_question)).distinct
        anonymous_noties.each do |n|
          n.destroy if n.recipient != @custom_question.author
        end
      end
      ########################################

      channel_names = ''
      selected_channels.each do |c| 
        channel_names += c.name + ' '
      end

      @comments = @custom_question.comments.where(anonymous: false).sort_by(&:created_at)
      
      @comments = @comments.paginate(:page => params[:page], :per_page => 5, :param_name => :comment_page)

      render json: @custom_question, channels: channel_names, comments: @comments, serializer: CustomQuestionShowSerializer
      # render :custom_question, locals: { custom_question: @custom_question }
    else
      render json: {
        status: 'ERROR',
        message: 'custom question not updated',
        data: @custom_question.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def friend_comments
    @comments = @custom_question.comments.where(anonymous: false).sort_by(&:created_at)
    @comments = @comments.paginate(:page => params[:page], :per_page => 10)
 
    render json: @comments, adapter: :json_api, each_serializer: CommentSerializer
  end

  def general_comments
    @comments = @custom_question.comments.where(anonymous: true).sort_by(&:created_at)
    @comments = @comments.paginate(:page => params[:page], :per_page => 10)

    render json: @comments, adapter: :json_api, each_serializer: CommentSerializer
  end

  def likes
    render json: @custom_question.likes, each_serializer: LikeSerializer
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

  def set_custom_question
    @custom_question = CustomQuestion.find(params[:id])
  end

  def custom_question_params
    params.require(:custom_question).permit(:author_id, :content, :tag_string, :repost_message)
  end

  def check_mine
    # redirect_to root_url if @answer.author_id != current_user.id
    if @custom_question.author_id != current_user.id
      render json: {status: 'ERROR', message:'not mine', data: current_user}, status: :unauthorized
    end
  end

  def check_accessibility
    author = CustomQuestion.find(params[:id]).author
    if (author.friends.include? current_user) && (author != current_user) && (!CustomQuestion.accessible(current_user.id).exists?(params[:id]))
      # redirect_to root_url
      render json: {status: 'ERROR', message:'not accessible', data: current_user}, status: :unauthorized
    elsif !(author.friends.include? current_user) && (author != current_user) && (CustomQuestion.find(params[:id]).channels.none? { |c| c.name == '익명피드' })
      # redirect_to root_url
      render json: {status: 'ERROR', message:'not accessible', data: current_user}, status: :unauthorized
    end
  end

  def ajax_request?
    (defined? request) && request.xhr?
  end
end
