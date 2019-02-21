class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]
  before_action :check_mine, only: %i[edit update destroy]
  before_action :check_accessibility, only: [:show]
 
  def create
    # @post = Post.create(post_params)
    @post = Post.new(post_params)
    if @post.save
      render json: {status: 'SUCCESS', message:'Created post', data: @post}, status: :ok
    else
      render json: {status: 'ERROR', message:'Post not saved', data: @post.errors.full_messages}, status: :unprocessable_entity
    end

    channels = [] # 선택된 채널들을 갖고 있다.
    channels = Channel.find(params[:c]) if params[:c]
    channels.each do |c|
      Entrance.create(channel: c, target: @post)
    end 
  end

  def show
    @anonymous = (@post.author_id != current_user.id) && !(current_user.friends.include? @post.author)

    render :show, locals: { anonymous: @anonymous, answer: @post }
  end

  def edit
    render :edit, locals: { post: @post }
  end

  def update
    if @post.update(post_params)

      original_channels = @post.channels
      selected_channels = []
      selected_channels = Channel.find(params[:c]) if params[:c]
      # 안겹치는 애들만 모아다가
      changed_channels = selected_channels - original_channels
      changed_channels += original_channels - selected_channels
      # 바꿔줍니다
      changed_channels.each do |c|
        e = Entrance.find_or_initialize_by(channel: c, target: @post)
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
      friend_noties += Notification.where(target_type: 'Like', action: 'friend_like_comment').joins(comment_join).merge(Comment.where(target: @post)).distinct
      friend_noties += Notification.where(target_type: 'Like', action: 'friend_like_reply').joins(reply_join).merge(Reply.joins(:comment).where(comments: { target: @post })).distinct
      friend_noties += Notification.where(target_type: 'Reply', action: 'friend_to_comment').joins(comment_join).merge(Comment.where(target: @post)).distinct
      friend_noties += Notification.where(target_type: 'Reply', action: 'friend_to_recomment').joins(comment_join).merge(Comment.where(target: @post)).distinct

      friend_noties.each do |n|
        if (n.recipient != @post.author) && (n.recipient.belonging_channels & selected_channels).empty?
          n.destroy
        end
      end

      if (original_channels.any? { |c| c.name == '익명피드' }) && (selected_channels.none? { |c| c.name == '익명피드' }) # 원래 익명피드 공개였는데 바뀐 경우에만
        anonymous_noties = []
        anonymous_noties += Notification.where(target_type: 'Like', action: 'anonymous_like_comment').joins(comment_join).merge(Comment.where(target: @post)).distinct
        anonymous_noties += Notification.where(target_type: 'Like', action: 'anonymous_like_reply').joins(reply_join).merge(Reply.joins(:comment).where(comments: { target: @post })).distinct
        anonymous_noties += Notification.where(target_type: 'Reply', action: 'anonymous_to_comment').joins(comment_join).merge(Comment.where(target: @post)).distinct
        anonymous_noties.each do |n|
          n.destroy if n.recipient != @post.author
        end
      end
      ########################################

      channel_names = ''
      selected_channels.each do |c|
        channel_names += c.name + ' '
      end

      render :update, locals: { channel_names: @channel_names, post: @post }
    else
      redirect_to root_url
    end
  end

  def destroy
    render json: {status: 'ERROR', message:'Post not updated', data: @post.errors.full_messages}, status: :unprocessable_entity
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:author_id, :content)
  end

  def check_mine
    redirect_to root_url if @post.author_id != current_user.id
  end

  def check_accessibility
    author = Post.find(params[:id]).author
    if (author.friends.include? current_user) && (author != current_user) && (!Post.accessible(current_user.id).exists?(params[:id]))
      redirect_to root_url
    elsif !(author.friends.include? current_user) && (author != current_user) && (Post.find(params[:id]).channels.none? { |c| c.name == '익명피드' })
      redirect_to root_url
    end
  end

  def ajax_request?
    (defined? request) && request.xhr?
  end
end
