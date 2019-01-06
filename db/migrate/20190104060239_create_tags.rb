class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.belongs_to :author,          null: false, foreign_key: { to_table: :users }
      t.string   :content, null: false
      t.integer  :target_id
      t.string   :target_type

      t.timestamps
    end
  end
end
