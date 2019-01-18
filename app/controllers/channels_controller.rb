class ChannelsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_channel, except: [:create]

    def create
        Channel.create(user_id: current_user.id, name: params[:name])    
        render json: {
            # FIXME: 뭘 보내야하는지 몰라서 비워둡니다 ajax 부탁드립니다
        }
    end

    def destroy
        @channel.destroy

        render json: {

        }
    end

    # add friend to a channel
    def add_friendship
        friendship_hash = {user_id: current_user.id, friend_id: params[:friend_id]}
        friendship = Friendship.where(friendship_hash).first
        friendship.channels << @channel
    end

    # delete friend from a channel
    def delete_friendship
        friendship_hash = {user_id: current_user.id, friend_id: params[:friend_id]}
        friendship = Friendship.where(friendship_hash).first
        friendship.channels.delete(@channel)
    end

    def edit_friendship
        #channel params[:id]
        #json [{friend_id:[1,3,4]}]
        # if friendship.channels.include? channel -> delete. not include-> add
        puts "========="
        puts params[:friend_ids]

        friends_ids = params[:friend_ids]

        friends_ids.each do |friend_id|
            friendship_hash = {user_id: current_user.id, friend_id: friend_id}
            friendship = Friendship.where(friendship_hash).first
            if friendship.channels.include? @channel
                friendship.channels.delete(@channel)
            else
                friendship.channels << @channel
            end
        end
        
        render json: {
        }
    end

    # add post to a channel (글의 공개범위 수정할 때만 필요, 처음 post생성 시에는 post create에서 entrance 처리됨)
    def add_post
        entrance_hash = {target_type: 'Post', target_id: params[:target_id], channel: @channel}
        entrance = Entrance.where(entrance_hash)
        if entrance.empty?
            Entrance.create(entrance_hash)
        end

    end

    # delete post from a channel
    def delete_post
        entrance_hash = {target_type: 'Post', target_id: params[:target_id], channel: @channel}
        entrance = Entrance.where(entrance_hash)
        if entrance.exists?
            entrance.destroy_all
        end

    end

    def add_answer
        entrance_hash = {target_type: 'Answer', target_id: params[:target_id], channel: @channel}
        entrance = Entrance.where(entrance_hash)
        if entrance.empty?
            Entrance.create(entrance_hash)
        end
    end

    def delete_answer
        entrance_hash = {target_type: 'Answer', target_id: params[:target_id], channel: @channel}
        entrance = Entrance.where(entrance_hash)
        if entrance.exists?
            entrance.destroy_all
        end
    end

    private
        def set_channel
            @channel = Channel.find(params[:id])
        end
    
end
