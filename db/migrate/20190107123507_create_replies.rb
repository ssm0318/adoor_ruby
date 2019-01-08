class CreateReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :replies do |t|
      t.belongs_to :author,          null: false, foreign_key: { to_table: :users }
      t.belongs_to :comment,         null: false
      t.text       :content,         null: false

      t.timestamps
    end
  end
end
