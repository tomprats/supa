module Admin
  class StatsController < ApplicationController
    before_action :check_admin_level

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
        redirect_to admin_games_path, success: "Stats were successfully updated"
      else
        redirect_back danger: @game.errors.try(:messages).to_s
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
      unless current_user.is_real_admin?
        redirect_to profile_path, danger: "You are not authorized to be there!"
      end
    end
  end
end
