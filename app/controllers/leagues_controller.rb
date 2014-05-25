class LeaguesController < ApplicationController
 before_filter :check_admin_level

  def create
    if League.create(league_params).valid?
      redirect_to :back, notice: "League was successfully created"
    else
      redirect_to :back, alert: "League could not be created"
    end
  end

  def edit
    @league = League.find(params[:id])
  end

  def activate
    league = League.find(params[:id])
    if league.update_attributes(active: params[:active])
      redirect_to :back, notice: "League has been updated"
    else
      redirect_to :back, alert: "League cannot be updated"
    end
  end

  def update
    if League.find(params[:id]).update_attributes(league_params)
      redirect_to :back, notice: "League was successfully updated"
    else
      redirect_to :back, alert: "League could not be updated"
    end
  end

  private
  def league_params
    params.require(:league).permit(:season, :year, :price, :active, :late_price)
  end

  def check_admin_level
    if current_user.admin != "super"
      redirect_to profile_path, notice: "You are not authorized to be there!"
    end
  end
end
