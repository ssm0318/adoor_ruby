class CreateTmis < ActiveRecord::Migration[5.1]
  def change
    create_table :tmis do |t|
      t.belongs_to :author,            null: false, foreign_key: { to_table: :users }
 
      t.timestamps
    end
  end
end
