class CreateJoinTableChannelFriendship < ActiveRecord::Migration[5.1]
  def change
    create_join_table :channels, :friendships do |t|
      t.index [:channel_id, :friendship_id]
      t.index [:friendship_id, :channel_id]
    end
  end
end
