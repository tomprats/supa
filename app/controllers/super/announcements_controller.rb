module Super
  class AnnouncementsController < ApplicationController
    before_action :check_admin_level

    def index
      @announcements = Announcement.all
    end

    def create
      if Announcement.create(announcement_params.merge!(creator_id: current_user.id)).valid?
        redirect_to super_announcements_path, success: "Announcement was successfully created"
      else
        redirect_back alert: "Announcement could not be created"
      end
    end

    def edit
      @announcement = Announcement.find(params[:id])
    end

    def update
      if Announcement.find(params[:id]).update_attributes(announcement_params)
        redirect_to super_announcements_path, success: "Announcement was successfully updated"
      else
        redirect_back alert: "Announcement could not be updated"
      end
    end

    def destroy
      if Announcement.find(params[:id]).destroy
        redirect_to super_announcements_path, success: "Announcement was successfully destroyed"
      else
        redirect_back alert: "Announcement could not be destroyed"
      end
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, success: "You are not authorized to be there!"
      end
    end

    def announcement_params
      params.require(:announcement).permit(:heading, :text, :importance)
    end
  end
end
