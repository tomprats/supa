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

    Game.all.each do |game|
      event = Event.create(
        title: game.name,
        field_id: game.field_id,
        league_id: game.league_id,
        creator_id: game.creator_id,
        datetime: game.datetime,
      )
      game.update_attributes(event_id: event.id)
    end

    remove_column :games, :name
    remove_column :games, :field_id
    remove_column :games, :league_id
    remove_column :games, :creator_id
    remove_column :games, :datetime
  end
end
