class TeamsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def show
    if params[:id]
      @team = Team.find(params[:id])
    elsif current_user.team
      @team = current_user.team
    else
      redirect_to profile_path, :notice => "You don't have a team yet!"
    end
  end
end
