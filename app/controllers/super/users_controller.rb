module Super
  class UsersController < ApplicationController
    before_filter :check_admin_level

    def index
      key = params[:key] || "last_name"
      @supers = User.super.order("#{key} ASC")
      @standards = User.standard.order("#{key} ASC")
      @none = User.none.order("#{key} ASC")
      @late = User.not_on_a_team
    end

    def assign
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

        redirect_to super_users_path, notice: "Player successfully assigned."
      end
    end

    def trade
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

        redirect_to super_users_path, notice: "Player successfully assigned."
      end
    end

    def update
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
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end

    def user_params
      params.required(:user).permit(
        :first_name,
        :last_name,
        :email,
        :phone_number,
        :admin
      )
    end
  end
end