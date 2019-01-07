class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.belongs_to :author,          null: false, foreign_key: { to_table: :users }
      t.text       :content,         null: false

      t.timestamps
    end
  end
end
