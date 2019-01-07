class CreateQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :queries do |t|
      t.belongs_to :user
      t.string     :content

      t.timestamps
    end
  end
end
