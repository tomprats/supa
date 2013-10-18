class AddTeamsTable < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string  :name
      t.integer :captain

      t.timestamps
    end

    create_table :teams_users do |t|
      t.belongs_to :team
      t.belongs_to :user
    end

    add_index :teams_users, [:team_id, :user_id]
  end
end
