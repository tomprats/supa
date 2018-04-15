module Captain
  class CaptainsController < ApplicationController
    before_action :check_admin_level

    def index
      @current_team = current_user.captains_team
      @teams = current_user.captains_teams
      @users = User.registered.table_list
    end

    private
    def check_admin_level
      unless current_user.is_captain?
        redirect_to profile_path, danger: "You are not authorized to be there!"
      end
    end
  end
end
