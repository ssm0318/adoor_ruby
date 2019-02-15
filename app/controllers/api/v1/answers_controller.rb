class Api::V1::AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[show edit update destroy]
  before_action :check_mine, only: %i[edit update destroy]
  before_action :check_accessibility, only: [:show]

  def new
    @question = Question.find(params[:id])

    render :new, locals: { question: @question }
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.save

    channels = [] # 선택된 채널들을 갖고 있다.
    channels = Channel.find(params[:c]) if params[:c]
    channels.each do |c|
      Entrance.create(channel: c, target: @answer)
    end

    # assign 당한 유저C가 해당 질문에 대해 답하면 그 질문에 대해 유저C를 assign한 모든 유저들에게 보내지는 노티 생성.
    assignment_hash = { target: @answer, assignee_id: @answer.author_id }
    Assignment.where(assignment_hash).find_each do |assignment|
      # 답변의 공개그룹에 assigner가 포함되어있는 경우에만 노티가 감.
      unless (channels & assignment.assigner.belonging_channels).empty?
        Notification.create(recipient: assignment.assigner, actor: @answer.author, target: @answer, origin: @answer, action: 'assignment-answer')
      end
    end

    @channel_names = []
    channels.each do |c|
      @channel_names.push(c.name)
    end

    if @answer
      render :answer, locals: { channel_names: @channel_names, answer: @answer }
      # render json: {status: 'SUCCESS', message:'Created answer', data: @answer}, status: :ok
    else
      render json: {status: 'ERROR', message:'Answer not saved', data: @answer.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show
    @anonymous = @answer.author_id != current_user.id && !(current_user.friends.include? @answer.author)

    render :show, locals: { anonymous: @anonymous, answer: @answer }
  end

  def edit
    @question = @answer.question

    render :edit, locals: { question: @question, answer: @answer }
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

      ################################## 테스팅 완료 - 우와 명석왕님 너무 훌륭합니다...!!
      # 공개 범위의 변화로 인해 못 보게 된 글 / 댓글에 대한 노티를 모두 삭제한다
      ## 친구공개였다가 아니게 된 것 : 거기 댓글 / 대댓글 단 친구들에게 간 노티 다 없어짐
      ## 익명피드 공개였다가 아니게 된 것 : 거기 댓글 / 대댓글 단 사람들한테 간 노티 다 없어짐
      # visible이고 아니고 다 지우는 걸로 일단 했다
      ## 즉, 범위를 두 번 바꾼다고 해서 예전 노티가 다시 살아나진 않음
      comment_join = "INNER JOIN comments ON notifications.origin_id = comments.id AND notifications.origin_type = 'Comment'"
      reply_join = "INNER JOIN replies ON notifications.origin_id = replies.id AND notifications.origin_type = 'Reply'"

      friend_noties = []
      friend_noties += Notification.where(target_type: 'Like', action: 'friend_like_comment').joins(comment_join).merge(Comment.where(target: @answer)).distinct
      friend_noties += Notification.where(target_type: 'Like', action: 'friend_like_reply').joins(reply_join).merge(Reply.joins(:comment).where(comments: { target: @answer })).distinct
      friend_noties += Notification.where(target_type: 'Reply', action: 'friend_to_comment').joins(comment_join).merge(Comment.where(target: @answer)).distinct
      friend_noties += Notification.where(target_type: 'Reply', action: 'friend_to_recomment').joins(comment_join).merge(Comment.where(target: @answer)).distinct

      friend_noties.each do |n|
        if (n.recipient != @answer.author) && (n.recipient.belonging_channels & selected_channels).empty?
          n.destroy
        end
      end

      if original_channels.any? { |c| c.name == '익명피드' } && selected_channels.none? { |c| c.name == '익명피드' } # 원래 익명피드 공개였는데 바뀐 경우에만
        anonymous_noties = []
        anonymous_noties += Notification.where(target_type: 'Like', action: 'anonymous_like_comment').joins(comment_join).merge(Comment.where(target: @answer)).distinct
        anonymous_noties += Notification.where(target_type: 'Like', action: 'anonymous_like_reply').joins(reply_join).merge(Reply.joins(:comment).where(comments: { target: @answer })).distinct
        anonymous_noties += Notification.where(target_type: 'Reply', action: 'anonymous_to_comment').joins(comment_join).merge(Comment.where(target: @answer)).distinct
        anonymous_noties.each do |n|
          n.destroy if n.recipient != @answer.author
        end
      end
      ########################################

      @channel_names = []
      selected_channels.each do |c|
        @channel_names.push(c.name)
      end

      render :answer, locals: { channel_names: @channel_names, answer: @answer }
    else
      render json: {status: 'ERROR', message:'Answer not updated', data: @answer.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    if @answer.destroy
      render json: {status: 'SUCCESS', message:'Deleted answer'},status: :ok
    else
      render json: {status: 'ERROR', message:'Answer not deleted', data: @answer.errors.full_messages}, status: :unprocessable_entity
    end
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

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:author_id, :question_id, :content, :tag_string)
  end

  def check_mine
    # redirect_to root_url if @answer.author_id != current_user.id
    if @answer.author_id != current_user.id
      render json: {status: 'ERROR', message:'not mine', data: current_user}, status: :unauthorized
    end
  end

  def check_accessibility
    author = Answer.find(params[:id]).author
    if (author.friends.include? current_user) && author != current_user && !Answer.accessible(current_user.id).exists?(params[:id])
      # redirect_to root_url
      render json: {status: 'ERROR', message:'not accessible', data: current_user}, status: :unauthorized
    elsif !(author.friends.include? current_user) && author != current_user && Answer.find(params[:id]).channels.none? { |c| c.name == '익명피드' }
      # redirect_to root_url
      render json: {status: 'ERROR', message:'not accessible', data: current_user}, status: :unauthorized
    end
  end

  def ajax_request?
    (defined? request) && request.xhr?
  end
end
