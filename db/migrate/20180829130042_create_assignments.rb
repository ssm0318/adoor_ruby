class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.belongs_to :question,            null: false
      t.belongs_to :assigner,            null: false, foreign_key: { to_table: :users }
      t.belongs_to :assignee,            null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
