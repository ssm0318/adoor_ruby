class AddTagStringToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :tag_string, :string
  end
end
