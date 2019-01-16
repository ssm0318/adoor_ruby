class ChannelsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_channel, only: [:add_friendship]

    def create
        Channel.create(user_id: current_user.id, name: params[:name])    
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

    private
        def set_channel
            @channel = Channel.find(params[:id])
        end
    
end
