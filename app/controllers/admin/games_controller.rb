module Admin
  class GamesController < ApplicationController
    before_filter :check_admin_level

    def create
      params[:game][:event_attributes][:datetime] = convert_to_datetime(params[:game].delete(:date), params[:game].delete(:time))
      @game = Game.create(game_params.merge!(creator_id: current_user.id))
      if @game.valid?
        redirect_to admin_games_path, notice: "Game was successfully created"
      else
        redirect_to :back, alert: "Game could not be created"
      end
    end

    def index
      new_game

      @games = Game.all
      @current_games = League.summer.games
      @past_games = Game.where.not(id: @current_games.collect(&:id))
    end

    def edit
      @game = Game.find(params[:id])
    end

    def update
      params[:game][:event_attributes][:datetime] = convert_to_datetime(params[:game].delete(:date), params[:game].delete(:time))
      if Game.find(params[:id]).update_attributes(game_params)
        redirect_to admin_games_path, notice: "Game was successfully updated"
      else
        redirect_to :back, alert: "Game could not be updated"
      end
    end

    def destroy
      if Game.find(params[:id]).destroy
        redirect_to admin_games_path, notice: "Game was successfully destroyed"
      else
        redirect_to :back, alert: "Game could not be destroyed"
      end
    end

    private
    def game_params
      params.require(:game).permit(
        event_attributes: [:id, :league_id, :datetime, :field_id, :title],
        team_stats1_attributes: [:id, :team_id],
        team_stats2_attributes: [:id, :team_id]
      )
    end

    def convert_to_datetime(date, time)
      DateTime.strptime("#{date} #{time}", "%m/%d/%Y %I:%M %p") if !date.blank? && !time.blank?
    end

    def new_game
      @game = Game.new
      @game.build_event
      @game.build_team_stats1
      @game.build_team_stats2
      @game.team_stats1.player_stats.build
      @game.team_stats2.player_stats.build
    end

    def check_admin_level
      unless current_user.is_real_admin?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end
  end
end
