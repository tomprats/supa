class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string   :title
      t.string   :text
      t.integer  :field_id
      t.integer  :league_id
      t.integer  :creator_id
      t.datetime :datetime
    end
    add_column :games, :event_id, :integer

    remove_column :games, :name
    remove_column :games, :field_id
    remove_column :games, :league_id
    remove_column :games, :creator_id
    remove_column :games, :datetime
  end
end
