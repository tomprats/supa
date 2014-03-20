class AdminsController < ApplicationController
 before_filter :check_admin_level

  def super
    @announcement = Announcement.new
    @field = Field.new
    @draft = Draft.new
    @drafts = Draft.all
    @team = Team.new

    key = params[:key] || "last_name"
    @announcements = Announcement.all
    @fields = Field.all
    @supers = User.super.order("#{key} ASC")
    @standards = User.standard.order("#{key} ASC")
    @none = User.none.order("#{key} ASC")
  end

  def standard
    @team = Team.new
    new_game

    @teams = Team.all
    @current_teams = Team.active
    @inactive_teams = Team.inactive

    @captains = @teams.collect { |t| t.captain }
    @current_captains = @current_teams.collect { |t| t.captain }
    @inactive_captains = @inactive_teams.collect { |t| t.captain }

    key = params[:key] || "last_name"
    @users = User.all.order("#{key} ASC")
    @registered_users = User.registered.order("#{key} ASC")
    @unregistered_users = User.unregistered.order("#{key} ASC")

    @games = Game.all
    @current_games = Game.active
    @inactive_games = Game.inactive
  end

  def captain
    new_game

    @current_team = Team.active.find_by(:captain_id => current_user.id)
    @teams = current_user.captains_teams
    @users = User.registered
  end

  def update_user
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    redirect_to super_path, :notice => "User updated successfully!"
  end

  private
  def user_params
    params.required(:user).permit(:first_name,
                                  :last_name,
                                  :email,
                                  :phone_number,
                                  :admin)
  end

  def new_game
    @game = Game.new
    @game.build_team_stats1
    @game.build_team_stats2
    team = current_user.teams.active.first.try(:id)
    @game.winner_id = team
    @game.loser_id = team
    @game.team_stats1.player_stats.build
    @game.team_stats2.player_stats.build
  end

  def check_admin_level
    case action_name
    when "super", "create_draft"
      if current_user.admin != "super"
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    when "standard"
      if current_user.admin == "none"
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    when "captain"
      if !current_user.is_captain?
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    end
  end
end

