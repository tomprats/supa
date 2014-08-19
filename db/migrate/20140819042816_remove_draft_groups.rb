class RemoveDraftGroups < ActiveRecord::Migration
  def up
    remove_column :draft_players, :draft_group_id
    remove_column :draft_players, :position
    remove_column :draft_players, :rating
    remove_column :drafted_players, :position

    drop_table :draft_groups
    rename_table :draft_players, :tentative_players

    add_column :tentative_players, :draft_id, :integer
    add_column :tentative_players, :team_id, :integer
  end

  def down
    remove_column :tentative_players, :draft_id
    remove_column :tentative_players, :team_id

    rename_table :tentative_players, :draft_players
    create_table :draft_groups do |t|
      t.string :name
    end

    add_column :draft_players, :draft_group_id, :integer
    add_column :draft_players, :position, :string
    add_column :draft_players, :rating, :integer
    add_column :drafted_players, :position, :string
  end
end
