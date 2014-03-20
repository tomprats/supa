class GamesController < ApplicationController
 before_filter :check_admin_level, except: [:show]

  def create
    params[:game][:datetime] = convert_to_datetime(params[:game][:date], params[:game][:time])
    if Game.create(game_params.merge!(creator_id: current_user.id)).valid?
      redirect_to :back, notice: "Game was successfully created"
    else
      redirect_to :back, alert: "Game could not be created"
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    params[:game][:datetime] = convert_to_datetime(params[:game][:date], params[:game][:time])
    if Game.find(params[:id]).update_attributes(game_params)
      redirect_to :back, notice: "Game was successfully updated"
    else
      redirect_to :back, alert: "Game could not be updated"
    end
  end

  def destroy
    if Game.find(params[:id]).destroy
      redirect_to :back, notice: "Game was successfully destroyed"
    else
      redirect_to :back, alert: "Game could not be destroyed"
    end
  end

  private
  def game_params
    params.require(:game).permit(:datetime, :field_id, :name,
      team_stats1_attributes: [:id, :team_id],
      team_stats2_attributes: [:id, :team_id]
    )
  end

  def convert_to_datetime(date, time)
    DateTime.strptime("#{date} #{time}", "%m/%d/%Y %I:%M %p")
  end

  def check_admin_level
    if current_user.admin == "none"
      redirect_to profile_path, :notice => "You are not authorized to be there!"
    end
  end
end
