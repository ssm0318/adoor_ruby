class CreateHighlights < ActiveRecord::Migration[5.1]
  def change
    create_table :highlights do |t|
      t.belongs_to :user,           null: false
      t.belongs_to :target_id
      t.belongs_to :target_type
      t.text       :content,        null: false

      t.timestamps
    end
  end
end
