class CreateJoinTableCustomQuestionTag < ActiveRecord::Migration[5.1]
  def change
    create_join_table :custom_questions, :tags do |t|
      t.index [:custom_question_id, :tag_id]
      t.index [:tag_id, :custom_question_id]
    end
  end
end
