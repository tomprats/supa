class AdminsController < ApplicationController
  before_filter :check_admin_level

  def captain
    @current_team = League.summer.teams.find_by(captain_id: current_user.id)
    @teams = current_user.captains_teams
    @users = User.registered
  end

  private
  def check_admin_level
    unless current_user.is_captain?
      redirect_to profile_path, notice: "You are not authorized to be there!"
    end
  end
end
