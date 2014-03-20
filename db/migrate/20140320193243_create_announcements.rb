class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :heading
      t.text :text
      t.integer :creator_id
      t.integer :importance, default: 0

      t.timestamps
    end
  end
end
