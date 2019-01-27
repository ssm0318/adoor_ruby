class CreateChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :channels do |t|
      t.belongs_to  :user,         null: false, foreign_key: { to_table: :users }
      t.string      :name,         null: false

      t.timestamps
    end
  end
end
