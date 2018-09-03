class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      # 별도의 author가 parameter로 전해지지 않으면 default로 admin (1번 유저)가 author로 넣어짐.
      # Question belongs_to User이기 때문에 nil로 둘 수 없는 것 같음.
      t.integer    :author_id,          { default: 1 }  
      t.string     :content,            null: false 
      
      t.timestamps
    end
  end
end
