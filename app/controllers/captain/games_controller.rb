module Captain
  class GamesController < ApplicationController
    before_filter :check_admin_level

    def index
      @current_team = current_user.captains_team
      @games = @current_team.games
    end

    def show
      if params[:id] == "league"
        league = League.current
        games = league.games

        @pdf = GamesPdf.new(games)
        @name = league.name
      elsif params[:id] == "team"
        team = current_user.captains_team
        games = team.games

        @pdf = GamesPdf.new(games)
        @name = team.name
      else
        game = Game.find(params[:id])

        @pdf = GamesPdf.new(game)
        @name = [game.name, game.datetime.strftime("%m-%d-%l-%M-%p")].join("-")
      end

      send_data @pdf.render,
        filename: @name.downcase.parameterize + ".pdf",
        type: "application/pdf",
        disposition: "inline"
    end

    private
    def check_admin_level
      unless current_user.is_captain?
        redirect_to profile_path, danger: "You are not authorized to be there!"
      end
    end
  end
end
