class RemoveWinnerIdAndLoserIdFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :winner_id
    remove_column :games, :loser_id
  end
end
