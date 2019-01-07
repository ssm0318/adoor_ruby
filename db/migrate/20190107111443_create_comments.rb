class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to :author,            null: false, foreign_key: { to_table: :users }
      t.belongs_to :recipient,         foreign_key: { to_table: :users }
      t.integer    :target_id  
      t.string     :target_type   
      t.text       :content,           null: false

      t.timestamps
    end
  end
end
 