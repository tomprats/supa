class AddLeagueIdToPlayerAwards < ActiveRecord::Migration
  def change
    add_column :player_awards, :league_id, :integer
  end
end
