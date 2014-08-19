module Captain
  class DraftedPlayersController < ApplicationController
    before_filter :check_admin_level

    def create
      draft = Draft.find(params[:drafted_player][:draft_id])
      player = User.find(params[:drafted_player][:player_id])

      create_from_hash({
        draft_id: draft.id,
        team_id: current_user.captains_team(draft.league_id).id,
        player_id: player.id,
        round: draft.round
      }, draft, player)
    end

    def create_from_tentative
      draft = Draft.find(params[:draft_id])
      tentative_player = current_user.captains_team(draft.league_id).tentative_players.find(params[:id])
      player = tentative_player.player

      create_from_hash({
        draft_id: tentative_player.draft_id,
        team_id: tentative_player.team_id,
        player_id: tentative_player.player_id,
        round: draft.round
      }, draft, player)
    end

    private
    def check_admin_level
      unless current_user.is_captain?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end

    def create_from_hash(hash, draft, player)
      if !draft.active?
        redirect_to :back, alert: "The draft has not started yet."
      elsif draft.my_turn?(current_user)
        if player.drafted?(draft.id)
          TentativePlayer.where(draft_id: draft.id, player_id: player.id).destroy_all
          redirect_to :back, alert: "Player already drafted."
        else
          @drafted_player = DraftedPlayer.create(hash)
          draft.update_turn
          unless draft.players_undrafted?
            draft.update_players
          end
          TentativePlayer.where(draft_id: draft.id, player_id: player.id).destroy_all
          redirect_to :back, notice: "Player successfully drafted."
        end
      else
        redirect_to :back, alert: "It is not your turn!"
      end
    end
  end
end
