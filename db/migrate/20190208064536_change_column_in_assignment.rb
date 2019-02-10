class ChangeColumnInAssignment < ActiveRecord::Migration[5.1]
  def up
    rename_column :assignments, :question_id, :target_id
    add_column :assignments, :target_type, :string
    Assignment.reset_column_information
    Assignment.update_all(:target_type => "Question")
  end

  def down
    remove_column :assignments, :target_type
    rename_column :assignments, :question_id, :target_id
  end
end
