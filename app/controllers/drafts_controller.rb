class DraftsController < ApplicationController
  skip_before_action :require_user!, :check_attr

  def feed
    if params[:id]
      @draft = Draft.find(params[:id])
    else
      @draft = League.current.draft
    end

    @drafted_players = @draft.drafted_players
    @total = @drafted_players.count
    @drafted_players = @drafted_players.where("position < ?", @draft.turn)
  end

  def turn
    draft = Draft.find(params[:id])
    render json: { turn: draft.turn }
  end
end
