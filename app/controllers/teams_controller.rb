class TeamsController < ApplicationController
  def create
    @team = Team.create(team_params)
    redirect_to :back, :notice => "#{@team.name} was successfully created."
  end

  def show
    if params[:id]
      @team = Team.find(params[:id])
    elsif current_user.team
      @team = current_user.team
    else
      redirect_to profile_path, :notice => "You don't have a team yet!"
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @team.update(team_params)
    redirect_to admin_path
  end

  def destroy
    @team = Team.find(params[:id]).destroy
    redirect_to :back, :notice => "#{@team.name} was successfully destroyed."
  end

  private
  def team_params
    params.require(:team).permit(:name,
                                 :captain_id,
                                 :season,
                                 :year,
                                 :active,
                                 :image,
                                 player_ids: []
                                )
  end
end
