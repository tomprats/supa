class AddGamesTable < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :winner_id
      t.integer :loser_id
      t.integer :creator_id
      t.integer :team_stats1_id
      t.integer :team_stats2_id
    end

    create_table :team_stats do |t|
      t.belongs_to :team
    end

    create_table :player_stats do |t|
      t.belongs_to :team_stats
      t.integer :player_id
      t.integer :assists
      t.integer :points
    end
  end
end
