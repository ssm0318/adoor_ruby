class CreateEntrances < ActiveRecord::Migration[5.1]
  def change
    create_table :entrances do |t|
      t.belongs_to :channel,             null: false
      t.integer  :target_id  
      t.string   :target_type   

      t.timestamps
    end
  end
end
