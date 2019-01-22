class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to :author,            null: false, foreign_key: { to_table: :users }
      # t.belongs_to :recipient,         foreign_key: { to_table: :users }
      t.integer    :target_id  
      t.string     :target_type   
      t.text       :content,           null: false
      # 태생이 secret인지 + anonymous인지를 create 할 때 정해줘야함
      t.boolean    :secret,             null: false, default: false         # 사용자가 바꿀 수 있음
      t.boolean    :anonymous,          null: false         # 사용자가 바꿀 수 없음 (한 번 익명댓글은 평생 익명댓글임! 친구가 되더라도)

      t.timestamps
    end
  end
end
 