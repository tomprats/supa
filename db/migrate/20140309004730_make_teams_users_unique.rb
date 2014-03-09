class MakeTeamsUsersUnique < ActiveRecord::Migration
  def change
    remove_index(:teams_users, name: "index_teams_users_on_team_id_and_user_id")
    add_index(:teams_users, [:team_id, :user_id], :unique => true)
  end
end
