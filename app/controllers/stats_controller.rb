class StatsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def index
    @league = params[:league_id] ? League.find(params[:league_id]) : League.current
    @players = @league.players
  end

  def standings
    @league = params[:league_id] ? League.find(params[:league_id]) : League.current
    @teams = @league.teams
  end
end
