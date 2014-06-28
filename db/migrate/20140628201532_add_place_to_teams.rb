class AddPlaceToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :place, :string
  end
end
