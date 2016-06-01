module Super
  class BaggagesController < ApplicationController
    before_filter :check_admin_level

    def index
      @current_baggages = League.current.baggages
      @baggages = Baggage.all
    end

    def approve
      baggage = Baggage.find(params[:id])
      if baggage.update_attributes(approved: !baggage.approved, approver_id: current_user.id)
        redirect_to :back, notice: "Baggage has been #{baggage.approved ? "approved" : "disapproved"}"
      else
        redirect_to :back, alert: "Baggage can not be approved"
      end
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end
  end
end
