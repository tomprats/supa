class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.string  :season
      t.integer :year
      t.boolean :active

      t.timestamps
    end

    create_table :draft_groups do |t|
      t.string     :name
      t.belongs_to :draft
      t.belongs_to :captain

      t.timestamps
    end

    create_table :draft_players do |t|
      t.belongs_to :draft_group
      t.belongs_to :player
      t.string     :position
      t.integer    :rating
      t.string     :info

      t.timestamps
    end
  end
end
