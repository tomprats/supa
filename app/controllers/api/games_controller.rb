module API
  class GamesController < ApplicationController
    def index
      @games = Game.pluck(keys)
      # Get teams from team stats
      render json: @games
    end

    def show
      @game = Game.find(params[:id]).pluck(keys)
      render json: @game
    end

    private
    def keys
      [:id, :team1_id, :team2_id]
    end
  end
end

