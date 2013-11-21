class AddTeamsTable < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string  :name
      t.integer :captain_id
      t.string  :season
      t.integer :year
      t.boolean :active, :default => :true
      t.string  :image

      t.timestamps
    end

    add_column :users, :active, :boolean, :default => :true

    create_table :teams_users do |t|
      t.belongs_to :team
      t.belongs_to :user
    end

    add_index :teams_users, [:team_id, :user_id]
  end
end
