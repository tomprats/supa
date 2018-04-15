module Captain
  class DraftedPlayersController < ApplicationController
    before_action :check_admin_level

    def create
      draft = Draft.find(params[:drafted_player][:draft_id])
      player = User.find(params[:drafted_player][:player_id])

      draft_player(draft, player)
    end

    def create_from_tentative
      draft = Draft.find(params[:draft_id])
      tentative_player = current_user.captains_team(draft.league_id).tentative_players.find(params[:id])
      player = tentative_player.player

      draft_player(draft, player)
    end

    private
    def check_admin_level
      unless current_user.is_captain?
        redirect_to profile_path, danger: "You are not authorized to be there!"
      end
    end

    def draft_player(draft, player)
      if !draft.active?
        redirect_back alert: "The draft has not started yet."
      elsif draft.my_turn?(current_user)
        if player.drafted?(draft.id)
          TentativePlayer.where(draft_id: draft.id, player_id: player.id).destroy_all
          redirect_back alert: "Player already drafted."
        else
          drafted_player = draft.current_pick
          drafted_player.update(player_id: player.id)
          draft_baggage(drafted_player)
          TentativePlayer.where(draft_id: draft.id, player_id: player.id).destroy_all

          more = draft.update_turn
          if (more && draft.players_undrafted?) || (!more && !draft.players_undrafted?)
            updated_players unless more
            redirect_back success: "Player successfully drafted."
          else
            redirect_back danger: "Organizer must update draft order."
          end
        end
      else
        redirect_back alert: "It is not your turn!"
      end
    end

    def draft_baggage(drafted_player)
      player_id = drafted_player.player.id
      draft = drafted_player.draft
      baggage = Baggage.find_by("""
        (league_id = :league_id)
        AND (approved = :approved)
        AND (partner1_id = :id OR partner2_id = :id)
      """, league_id: draft.league_id, approved: true, id: player_id)

      return unless baggage
      partner = baggage.other_partner(player_id)
      return if partner.drafted?(draft.id)
      return unless partner.registered?(draft.league_id)
      if drafted_baggage = drafted_player.team.drafted_players.find_by(player_id: nil)
        drafted_baggage.update(player_id: partner.id)
        TentativePlayer.where(draft_id: draft.id, player_id: partner.id).destroy_all
      end
    end
  end
end
