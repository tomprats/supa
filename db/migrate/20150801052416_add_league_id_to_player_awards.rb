class AddLeagueIdToPlayerAwards < ActiveRecord::Migration
  def change
    add_column :player_awards, :league_id, :integer

    league_id = League.where(season: "Summer").last.id
    PlayerAward.update_all(league_id: league_id)
  end
end
