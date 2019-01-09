class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer  :recipient_id,   null: false
      t.integer  :actor_id
      t.datetime :read_at  # 노티를 받은 사람이 노티를 언제 확인했는지      
      t.integer  :target_id  
      t.string   :target_type   
      t.integer  :origin_id
      t.string   :origin_type
      t.string   :action  # 현재는 필요하지 않지만 이후에 하나의 모델에 대해 여러가지 노티가 생길 수 있기 때문에 액션을 구분함.

      # reference: http://aalvarez.me/blog/posts/easy-notification-system-in-rails.html 참조
      t.timestamps
    end
  end
end
