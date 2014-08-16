class StatsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def index
    @players = User.registered
    @games = Game.all.select { |g| !g.team_stats1.player_stats.empty? }
    @teams = League.summer.teams
  end

  def show
    @game = Game.find(params[:game_id])
  end
end
