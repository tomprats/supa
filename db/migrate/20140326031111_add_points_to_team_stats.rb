class AddPointsToTeamStats < ActiveRecord::Migration
  def change
    add_column :team_stats, :goals, :integer
    add_column :player_stats, :goals, :integer
  end
end
