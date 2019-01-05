class CreateJoinTableAnswerTag < ActiveRecord::Migration[5.1]
  def change
    create_join_table :answers, :tags do |t|
      t.index [:answer_id, :tag_id]
      t.index [:tag_id, :answer_id]
    end
  end
end
