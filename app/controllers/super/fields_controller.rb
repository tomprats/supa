module Super
  class FieldsController < ApplicationController
    before_filter :check_admin_level

    def index
      @fields = Field.all
    end

    def create
      if Field.create(field_params).valid?
        redirect_to super_fields_path, success: "Field was successfully created"
      else
        redirect_to :back, danger: "Field could not be created"
      end
    end

    def edit
      @field = Field.find(params[:id])
    end

    def update
      if Field.find(params[:id]).update_attributes(field_params)
        redirect_to super_fields_path, success: "Field was successfully updated"
      else
        redirect_to :back, danger: "Field could not be updated"
      end
    end

    def destroy
      if Field.find(params[:id]).destroy
        redirect_to super_fields_path, success: "Field was successfully destroyed"
      else
        redirect_to :back, danger: "Field could not be destroyed"
      end
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, danger: "You are not authorized to be there!"
      end
    end

    def field_params
      params.require(:field).permit(:name, :location)
    end
  end
end
