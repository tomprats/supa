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
    @late = User.not_on_a_team
  end

  def standard
    new_game

    @teams = Team.all
    @current_teams = League.summer.teams
    @past_teams = Team.where.not(id: @current_teams.collect(&:id))

    @captains = @teams.collect { |t| t.captain }
    @current_captains = @current_teams.collect { |t| t.captain }
    @past_captains = @past_teams.collect { |t| t.captain }

    key = params[:key] || "last_name"
    @users = User.all.order("#{key} ASC")
    @registered_users = User.registered
    @not_registered_users = User.not_registered

    @games = Game.all
    @current_games = League.summer.games
    @past_games = Game.where.not(id: @current_games.collect(&:id))
  end

  def captain
    @current_team = League.summer.teams.find_by(captain_id: current_user.id)
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

  def assign_player
    league = League.current
    draft = league.draft
    player = User.find(params[:assign][:player_id])
    team = Team.find(params[:assign][:team_id])
    if !league.active?
      redirect_to :back, alert: "The league has not begun."
    elsif !draft.active?
      redirect_to :back, alert: "The draft has not started yet."
    elsif player.on_a_team?
      redirect_to :back, alert: "Player already on a team."
    else
      DraftedPlayer.create(
        team_id: team.id,
        player_id: player.id,
        position: "Late Register",
        round: draft.round,
        draft_id: draft.id
      )
      team.players << player

      redirect_to :back, notice: "Player successfully assigned."
    end
  end

  def trade_players
    league = League.current
    draft = league.draft
    player1 = User.find(params[:trade][:player1_id])
    player2 = User.find(params[:trade][:player2_id])
    if !league.active?
      redirect_to :back, alert: "The league has not begun."
    elsif !draft.active?
      redirect_to :back, alert: "The draft has not started yet."
    elsif !player1.on_a_team? || !player2.on_a_team?
      redirect_to :back, alert: "Player not on a team."
    elsif player1.team == player2.team
      redirect_to :back, alert: "Players on the same team."
    else
      team1 = player1.team
      team2 = player2.team
      DraftedPlayer.create(
        team_id: team2.id,
        player_id: player1.id,
        position: "Trade for #{player2.name}",
        round: draft.round,
        draft_id: draft.id
      )
      DraftedPlayer.create(
        team_id: team1,
        player_id: player2.id,
        position: "Trade for #{player1.name}",
        round: draft.round,
        draft_id: draft.id
      )
      team1.players.delete(player1)
      team2.players.delete(player2)
      team1.players << player2
      team2.players << player1

      redirect_to :back, notice: "Player successfully assigned."
    end
  end

  private
  def user_params
    params.required(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone_number,
      :admin
    )
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
