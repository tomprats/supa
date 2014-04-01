class FieldsController < ApplicationController
 before_filter :check_admin_level

  def create
    if Field.create(field_params).valid?
      redirect_to :back, notice: "Field was successfully created"
    else
      redirect_to :back, alert: "Field could not be created"
    end
  end

  def edit
    @field = Field.find(params[:id])
  end

  def update
    if Field.find(params[:id]).update_attributes(field_params)
      redirect_to :back, notice: "Field was successfully updated"
    else
      redirect_to :back, alert: "Field could not be updated"
    end
  end

  def destroy
    if Field.find(params[:id]).destroy
      redirect_to :back, notice: "Field was successfully destroyed"
    else
      redirect_to :back, alert: "Field could not be destroyed"
    end
  end

  private
  def field_params
    params.require(:field).permit(:name, :location)
  end

  def check_admin_level
    if current_user.admin != "super"
      redirect_to profile_path, notice: "You are not authorized to be there!"
    end
  end
end
