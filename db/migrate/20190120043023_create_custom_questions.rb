class CreateCustomQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_questions do |t|
      t.belongs_to  :author,     null: false, foreign_key: { to_table: :users }
      t.string      :content,  null: false
      t.boolean     :reposted, default: false
      t.string      :tag_string
      t.string      :repost_message

      t.timestamps
    end
  end
end