class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.belongs_to :author,          null: false, foreign_key: { to_table: :users }
      t.belongs_to :question,        null: false
      t.text       :content,         null: false
      # [TODO]: read_at 추가하기
      
      t.timestamps
    end
  end 
end
