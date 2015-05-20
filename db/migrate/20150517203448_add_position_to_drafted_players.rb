class AddPositionToDraftedPlayers < ActiveRecord::Migration
  def change
    remove_column :drafts, :snake, :integer
    add_column :drafted_players, :position, :integer
    remove_column :drafted_players, :round, :integer
    remove_column :drafts, :order, :text

    DraftedPlayer.destroy_all
  end
end
