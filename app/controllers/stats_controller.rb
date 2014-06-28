class StatsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  skip_before_filter :check_attr, only: [:index, :show]
  before_filter :check_admin_level, except: [:index, :show]

  def index
    @players = User.registered
    @games = Game.all.select { |g| !g.team_stats1.player_stats.empty? }
    @teams = League.summer.teams
  end

  def show
    @game = Game.find(params[:game_id])
  end

  def edit
    @game = Game.find(params[:game_id])
    if @game.team_stats1.player_stats.empty?
      @game.team1.players.each do |player|
        @game.team_stats1.player_stats.create(player_id: player.id)
      end
    end
    if @game.team_stats2.player_stats.empty?
      @game.team2.players.each do |player|
        @game.team_stats2.player_stats.create(player_id: player.id)
      end
    end
    render layout: false
  end

  def update
    @game =  Game.find(params[:game_id])
    if @game.update_attributes(game_params)
      redirect_to :back, notice: "Stats were successfully updated"
    else
      redirect_to :back, alert: @game.errors.try(:messages).to_s
    end
  end

  private
  def game_params
    params.require(:game).permit(
      team_stats1_attributes: [:id, player_stats_attributes: [:_destroy, :id, :player_id, :assists, :goals]],
      team_stats2_attributes: [:id, player_stats_attributes: [:_destroy, :id, :player_id, :assists, :goals]]
    )
  end

  def check_admin_level
    if current_user.admin == "none"
      redirect_to profile_path, notice: "You are not authorized to be there!"
    end
  end
end
