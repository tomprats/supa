module API
  class LeaguesController < ApplicationController
    def index
      @leagues = League.all.pluck(keys)
      render json: @leagues
    end

    def show
      @league = League.find(params[:id]).pluck(keys)
      render json: @league
    end

    private
    def keys
      [:id, :season, :year, :current]
    end
  end
end

