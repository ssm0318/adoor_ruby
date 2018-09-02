class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.integer    :author_id,          { default: 1 }
      t.string     :content,            null: false 
      
      t.timestamps
    end
  end
end
