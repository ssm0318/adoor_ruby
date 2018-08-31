class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.text     :content,            null: false
      
      t.timestamps
    end
  end
end
