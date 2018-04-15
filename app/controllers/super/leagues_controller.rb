module Super
  class LeaguesController < ApplicationController
    before_action :check_admin_level

    def index
      @leagues = League.all
    end

    def create
      if League.create(league_params).valid?
        redirect_to super_leagues_path, success: "League was successfully created"
      else
        redirect_back danger: "League could not be created"
      end
    end

    def edit
      @league = League.find(params[:id])
    end

    def update
      if League.find(params[:id]).update_attributes(league_params)
        redirect_to super_leagues_path, success: "League was successfully updated"
      else
        redirect_back danger: "League could not be updated"
      end
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, danger: "You are not authorized to be there!"
      end
    end

    def league_params
      params.require(:league).permit(:season, :year, :price, :late_price, :current, :state)
    end
  end
end
