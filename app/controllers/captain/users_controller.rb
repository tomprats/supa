module Captain
  class UsersController < ApplicationController
    before_filter :check_admin_level

    def index
      league = League.current
      pdf = UsersPdf.new(league)

      send_data pdf.render,
        filename: league.name.downcase.parameterize + ".pdf",
        type: "application/pdf",
        disposition: "inline"
    end

    private
    def check_admin_level
      unless current_user.is_captain? || current_user.is_super_admin?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end
  end
end
