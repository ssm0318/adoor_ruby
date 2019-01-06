class AddTagStringToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :tag_string, :string
  end
end
