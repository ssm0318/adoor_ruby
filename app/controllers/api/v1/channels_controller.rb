class Api::V1::ChannelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_channel, except: [:create]

  def create
    if !current_user.channels.where(name: params[:name]).empty?
      render json: {
        successed: false,
        message: "#{params[:name]} 채널은 이미 존재하는 채널입니다.",
        data: params[:name]
      }
    else
      @channel = Channel.create(user_id: current_user.id, name: params[:name])

      # render :channel, locals: { channel: @channel } 
    end
  end

  def update
    if !current_user.channels.where(name: params[:name]).empty? && (Channel.find(params[:id]).name != params[:name])
      render json: {
        successed: false,
        message: "#{params[:name]} 채널은 이미 존재하는 채널입니다.",
        data: params[:name]
      }
    else
      @channel.name = params[:name]
      @channel.save

      # render :channel, locals: { channel: @channel }
    end
  end

  def destroy
    if @channel.destroy
      render json: {status: 'SUCCESS', message:'Deleted channel'},status: :ok
    else
      render json: {status: 'ERROR', message:'channel not deleted', data: channel.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # add friend to a channel
  def add_friendship
    friendship_hash = { user_id: current_user.id, friend_id: params[:friend_id] }
    friendship = Friendship.where(friendship_hash).first
    friendship.channels << @channel

    # render :channel, locals: { channel: @channel }
  end

  # delete friend from a channel
  def delete_friendship
    friendship_hash = { user_id: current_user.id, friend_id: params[:friend_id] }
    friendship = Friendship.where(friendship_hash).first
    friendship.channels.delete(@channel)

    # render :channel, locals: { channel: @channel }
  end

  def edit_friendship
    friends_ids = params[:friend_ids]

    friends_ids.each do |friend_id|
      friendship_hash = { user_id: current_user.id, friend_id: friend_id }
      friendship = Friendship.where(friendship_hash).first
      if friendship.channels.include? @channel
        friendship.channels.delete(@channel)
      else
        friendship.channels << @channel
      end
    end

    # render :channel, locals: { channel: @channel }
  end

  # add post to a channel (글의 공개범위 수정할 때만 필요, 처음 post생성 시에는 post create에서 entrance 처리됨)
  def add_post
    entrance_hash = { target_type: 'Post', target_id: params[:target_id], channel: @channel }
    entrance = Entrance.where(entrance_hash)
    Entrance.create(entrance_hash) if entrance.empty?

    # render :channel, locals: { channel: @channel }
  end

  # delete post from a channel
  def delete_post
    entrance_hash = { target_type: 'Post', target_id: params[:target_id], channel: @channel }
    entrance = Entrance.where(entrance_hash)
    entrance.destroy_all if entrance.exists?

    # render :channel, locals: { channel: @channel }
  end

  def add_answer
    entrance_hash = { target_type: 'Answer', target_id: params[:target_id], channel: @channel }
    entrance = Entrance.where(entrance_hash)
    Entrance.create(entrance_hash) if entrance.empty?

    # render :channel, locals: { channel: @channel }
  end

  def delete_answer
    entrance_hash = { target_type: 'Answer', target_id: params[:target_id], channel: @channel }
    entrance = Entrance.where(entrance_hash)
    entrance.destroy_all if entrance.exists?

    # render :channel, locals: { channel: @channel }
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

  def set_channel
    @channel = Channel.find(params[:id])
  end
end
