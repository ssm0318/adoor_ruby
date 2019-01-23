class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      t.text    :content
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
