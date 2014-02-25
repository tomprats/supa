class DraftedPlayersController < ApplicationController
  before_filter :check_admin_level

  def create
    draft_player = DraftPlayer.find(params[:id])
    draft = draft_player.draft_group.draft
    player = draft_player.player

    if !draft.active?
      redirect_to :back, :alert => "The draft has not started yet."
    elsif draft.my_turn?(current_user)
      if player.drafted?(draft.id)
        redirect_to :back, :alert => "Player already drafted."
      else
        @drafted_player = DraftedPlayer.create(
          :team_id => current_user.captains_team.id,
          :player_id => player.id,
          :position => draft_player.position,
          :round => draft.round,
          :draft_id => draft.id
        )
        draft.update_turn
        unless draft.players_undrafted?
          draft.update_players
        end
        redirect_to :back, :notice => "Player successfully drafted."
      end
    else
      redirect_to :back, :alert => "It is not your turn!"
    end
  end

  def index
    @draft = Draft.find(params[:id])
    @drafted_players = @draft.drafted_players
  end

  def team
    @draft = Draft.find(params[:id])
    @drafted_players = @draft.drafted_players
  end

  private
  def check_admin_level
    case action_name
    when "create"
      if !current_user.is_captain?
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    end
  end
end
