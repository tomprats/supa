module API
  class TeamsController < ApplicationController
    def index
      @teams = Team.all.pluck(keys)
      # Needs Players
      render json: @teams
    end

    def show
      @team = Team.find(params[:id]).pluck(keys)
      render json: @team
    end

    private
    def keys
      [:id, :league_id, :captain_id, :name]
    end
  end
end

