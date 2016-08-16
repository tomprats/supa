class StatsController < ApplicationController
  skip_before_filter :require_user!, :check_attr

  def index
    @league = params[:league_id] ? League.find(params[:league_id]) : League.current
    @players = @league.players
  end

  def standings
    @league = params[:league_id] ? League.find(params[:league_id]) : League.current
    @teams = @league.teams
  end
end
