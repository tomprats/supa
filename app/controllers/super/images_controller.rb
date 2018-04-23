module Super
  class ImagesController < ApplicationController
    before_action :check_admin_level

    def index
      @images = Image.all
    end

    def create
      if Image.create(image_params.merge!(creator_id: current_user.id)).valid?
        redirect_to super_images_path, success: "Image was successfully created"
      else
        redirect_back alert: "Image could not be created"
      end
    end

    def edit
      @image = Image.find(params[:id])
    end

    def update
      if Image.find(params[:id]).update_attributes(image_params)
        redirect_to super_images_path, success: "Image was successfully updated"
      else
        redirect_back alert: "Image could not be updated"
      end
    end

    def destroy
      if Image.find(params[:id]).destroy
        redirect_to super_images_path, success: "Image was successfully destroyed"
      else
        redirect_back alert: "Image could not be destroyed"
      end
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, success: "You are not authorized to be there!"
      end
    end

    def image_params
      params.require(:image).permit(:link, :src, :importance)
    end
  end
end
