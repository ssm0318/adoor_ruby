class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.belongs_to :user,             null: false
      t.belongs_to :friend,           null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
