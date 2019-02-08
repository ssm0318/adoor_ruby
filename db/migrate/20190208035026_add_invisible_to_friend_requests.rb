class AddInvisibleToFriendRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :friend_requests, :invisible, :boolean, :default => false
  end
end
