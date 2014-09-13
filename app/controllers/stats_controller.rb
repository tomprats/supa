class StatsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def index
    @league = League.current
    @players = @league.players
  end

  def standings
    @league = League.current
    @teams = @league.teams
  end
end
