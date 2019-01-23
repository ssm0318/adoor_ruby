class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string     :content,            null: false 
      t.boolean    :official
      t.date       :selected_date
      t.string     :tag_string
      
      t.timestamps
    end
  end
end
