class AddDraftedPlayers < ActiveRecord::Migration
  def change
    create_table :drafted_players do |t|
      t.belongs_to :draft
      t.belongs_to :team
      t.belongs_to :player
      t.string     :position
      t.integer    :round

      t.timestamps
    end

    add_column :drafts, :turn, :integer, :default => 1
    add_column :drafts, :order, :text
  end
end
