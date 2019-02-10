class RemoveTargetIndexOnAssignments < ActiveRecord::Migration[5.1]
  def change
    remove_index :assignments, column: :target_id, unique: true
  end
end
