class CreateReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :replies do |t|
      t.belongs_to :author,          null: false, foreign_key: { to_table: :users }
      t.belongs_to :comment,         null: false
      t.text       :content,         null: false
      t.boolean    :secret,          null: false, default: false  # secret 설정이 된 대댓글을 볼 수 있는 사람은 글쓴이와 댓글쓴이
      t.boolean    :anonymous,       null: false

      t.timestamps
    end
  end
end
