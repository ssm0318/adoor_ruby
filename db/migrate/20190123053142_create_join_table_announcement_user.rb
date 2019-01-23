class CreateJoinTableAnnouncementUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :announcements, :users do |t|
      t.index [:announcement_id, :user_id]
      t.index [:user_id, :announcement_id]
    end
  end
end
