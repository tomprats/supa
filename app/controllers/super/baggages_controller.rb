module Super
  class BaggagesController < ApplicationController
    before_action :check_admin_level

    def index
      @current_baggages = League.current.baggages
      @baggages = Baggage.all
    end

    def approve
      baggage = Baggage.find(params[:id])
      if baggage.update_attributes(approved: !baggage.approved, approver_id: current_user.id)
        redirect_back success: "Baggage has been #{baggage.approved ? "approved" : "disapproved"}"
      else
        redirect_back alert: "Baggage can not be approved"
      end
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, success: "You are not authorized to be there!"
      end
    end
  end
end
