class AdminsController < ApplicationController
 before_filter :check_admin_level

  def super
    @announcements = Announcement.all
    @leagues = League.all
    @drafts = Draft.all
    @fields = Field.all
    key = params[:key] || "last_name"
    @supers = User.super.order("#{key} ASC")
    @standards = User.standard.order("#{key} ASC")
    @none = User.none.order("#{key} ASC")
  end

  def standard
    new_game

    @teams = Team.all
    @current_teams = League.most_recent.teams
    @past_teams = Team.where.not(id: @current_teams.collect(&:id))

    @captains = @teams.collect { |t| t.captain }
    @current_captains = @current_teams.collect { |t| t.captain }
    @past_captains = @past_teams.collect { |t| t.captain }

    key = params[:key] || "last_name"
    @users = User.all.order("#{key} ASC")
    @registered_users = User.registered
    @not_registered_users = User.not_registered

    @games = Game.all
    @current_games = League.most_recent.games
    @past_games = Game.where.not(id: @current_games.collect(&:id))
  end

  def captain
    @current_team = League.most_recent.teams.find_by(captain_id: current_user.id)
    @teams = current_user.captains_teams
    @users = User.registered
  end

  def update_admin
    @user = User.find(params[:id])
    if @user.email == "tprats108@gmail.com"
      redirect_to super_path, notice: "Good try..."
    else
      if params[:up] == "true"
        if @user.is_super_admin?
          redirect_to super_path, alert: "User already super admin!"
        elsif @user.is_real_admin?
          @user.update_attributes(admin: "super")
          redirect_to super_path, notice: "User updated successfully!"
        else
          @user.update_attributes(admin: "standard")
          redirect_to super_path, notice: "User updated successfully!"
        end
      else
        if @user.is_super_admin?
          @user.update_attributes(admin: "standard")
          redirect_to super_path, notice: "User updated successfully!"
        elsif @user.is_real_admin?
          @user.update_attributes(admin: "none")
          redirect_to super_path, notice: "User updated successfully!"
        else
          redirect_to super_path, alert: "User already isn't an admin!"
        end
      end
    end
  end

  private
  def user_params
    params.required(:user).permit(:first_name,
                                  :last_name,
                                  :email,
                                  :phone_number,
                                  :admin)
  end

  def check_admin_level
    case action_name
    when "super", "create_draft", "update_admin"
      if current_user.admin != "super"
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    when "standard"
      if current_user.admin == "none"
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    when "captain"
      if !current_user.is_captain?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end
  end

  def new_game
    @game = Game.new
    @game.build_team_stats1
    @game.build_team_stats2
    @game.team_stats1.player_stats.build
    @game.team_stats2.player_stats.build
  end
end
