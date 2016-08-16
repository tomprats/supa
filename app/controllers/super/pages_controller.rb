module Super
  class PagesController < ApplicationController
    before_filter :check_admin_level

    def index
      @pages = Page.all
    end

    def create
      if Page.create(page_params.merge!(creator_id: current_user.id)).valid?
        redirect_to super_pages_path, success: "Page was successfully created"
      else
        redirect_to :back, danger: "Page could not be created"
      end
    end

    def edit
      @page = Page.find(params[:id])
    end

    def update
      if Page.find(params[:id]).update_attributes(page_params)
        redirect_to super_pages_path, success: "Page was successfully updated"
      else
        redirect_to :back, danger: "Page could not be updated"
      end
    end

    def destroy
      if Page.find(params[:id]).destroy
        redirect_to super_pages_path, success: "Page was successfully destroyed"
      else
        redirect_to :back, danger: "Page could not be destroyed"
      end
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, danger: "You are not authorized to be there!"
      end
    end

    def page_params
      params.require(:page).permit(:name, :path, :text, :importance)
    end
  end
end
