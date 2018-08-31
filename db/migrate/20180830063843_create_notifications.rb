class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer  :recipient_id
      t.integer  :actor_id
      t.datetime :read_at
      # t.string   :action
      t.integer  :target_id
      t.string   :target_type

      # reference: http://aalvarez.me/blog/posts/easy-notification-system-in-rails.html 
      t.timestamps
    end
  end
end
