class AddCocaptainToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :cocaptain_id, :integer
  end
end
