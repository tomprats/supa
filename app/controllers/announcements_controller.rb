class AnnouncementsController < ApplicationController
 before_filter :check_admin_level

  def create
    if Announcement.create(announcement_params.merge!(creator_id: current_user.id)).valid?
      redirect_to :back, notice: "Announcement was successfully created"
    else
      redirect_to :back, alert: "Announcement could not be created"
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    if Announcement.find(params[:id]).update_attributes(announcement_params)
      redirect_to :back, notice: "Announcement was successfully updated"
    else
      redirect_to :back, alert: "Announcement could not be updated"
    end
  end

  def destroy
    if Announcement.find(params[:id]).destroy
      redirect_to :back, notice: "Announcement was successfully destroyed"
    else
      redirect_to :back, alert: "Announcement could not be destroyed"
    end
  end

  private
  def announcement_params
    params.require(:announcement).permit(:heading, :text, :importance)
  end

  def check_admin_level
    if current_user.admin != "super"
      redirect_to profile_path, notice: "You are not authorized to be there!"
    end
  end
end
