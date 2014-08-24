module Admin
  class TeamsController < ApplicationController
    before_filter :check_admin_level

    def create
      @team = Team.create(team_params)
      redirect_to admin_teams_path, :notice => "#{@team.name} was successfully created."
    end

    def index
      @teams = Team.all
      @current_teams = League.current.teams
      @past_teams = Team.where.not(id: @current_teams.collect(&:id))
    end

    def edit
      @team = Team.find(params[:id])
    end

    def update
      @team = Team.find(params[:id])
      @team.update(team_params)
      redirect_to admin_teams_path
    end

    def destroy
      @team = Team.find(params[:id]).destroy
      redirect_to admin_teams_path, :notice => "#{@team.name} was successfully destroyed."
    end

    private
    def team_params
      params.require(:team).permit(
        :name,
        :captain_id,
        :league_id,
        :place,
        :color,
        :active,
        :image,
        player_ids: []
      )
    end

    def check_admin_level
      unless current_user.is_real_admin?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end
  end
end
