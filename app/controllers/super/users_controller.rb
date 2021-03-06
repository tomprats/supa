module Super
  class UsersController < ApplicationController
    before_action :check_admin_level

    def index
      key = params[:key] || "last_name"
      @supers = User.super.order("#{key} ASC")
      @standards = User.standard.order("#{key} ASC")
      @none = User.simple.order("#{key} ASC")
      @late = User.not_on_a_team
    end

    def export
      @users = User.pluck(params[:export][:attributes])
      render layout: false
    end

    def shirt_sizes
      league = League.current
      pdf = ShirtSizesPdf.new(league)

      send_data pdf.render,
        filename: league.name.downcase.parameterize + ".pdf",
        type: "application/pdf",
        disposition: "inline"
    end

    def assign
      league = League.current
      draft = league.draft
      player = User.find(params[:assign][:player_id])
      team = Team.find(params[:assign][:team_id])
      if !(league.pre_draft? || league.in_progress?)
        redirect_back danger: "It's not time for that."
      elsif player.on_a_team?
        redirect_back danger: "Player already on a team."
      else
        unless league.pre_draft?
          DraftedPlayer.create(
            team_id: team.id,
            player_id: player.id,
            position: 0,
            draft_id: draft.id
          )
        end
        team.players << player

        redirect_back success: "Player successfully assigned."
      end
    end

    def trade
      league = League.current
      draft = league.draft
      player1 = User.find_by(id: params[:trade][:player1_id])
      player2 = User.find_by(id: params[:trade][:player2_id])
      team1 = player1.try(:team) || Team.find(params[:trade][:team1_id])
      team2 = player2.try(:team) || Team.find(params[:trade][:team2_id])
      if !(league.pre_draft? || league.in_progress?)
        redirect_back danger: "It's not time for that."
      elsif (player1 && !player1.on_a_team?) || (player2 && !player2.on_a_team?)
        redirect_back danger: "Player not on a team."
      elsif team1 == team2
        redirect_back danger: "Players on the same team."
      else
        if player1
          unless league.pre_draft?
            DraftedPlayer.create(
              team_id: team2.id,
              player_id: player1.id,
              position: 0,
              draft_id: draft.id
            )
          end
          team1.players.delete(player1)
          team2.players << player1
        end

        if player2
          unless league.pre_draft?
            DraftedPlayer.create(
              team_id: team1,
              player_id: player2.id,
              position: 0,
              draft_id: draft.id
            )
          end
          team2.players.delete(player2)
          team1.players << player2
        end

        redirect_back notice: "Players successfully traded."
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
  end
end
