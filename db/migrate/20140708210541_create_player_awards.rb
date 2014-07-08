class CreatePlayerAwards < ActiveRecord::Migration
  def change
    create_table :player_awards do |t|
      t.integer :user_id
      t.integer :most_valuable
      t.integer :offensive
      t.integer :defensive
      t.integer :rookie
      t.integer :female
      t.integer :comeback
      t.integer :captain
      t.integer :spirit
      t.integer :iron_man
      t.integer :most_outspoken
      t.integer :most_improved
      t.integer :hustle
      t.integer :best_layouts
      t.integer :most_underrated
      t.integer :sportsmanship
      t.string :ideas
    end
  end
end
