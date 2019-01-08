class CreateUserQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :user_queries do |t|
      t.belongs_to :user
      t.string     :content

      t.timestamps
    end
  end
end
