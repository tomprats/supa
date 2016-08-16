class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success, :info, :warning, :danger

  before_filter :require_user!, :check_attr

  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end
  helper_method :not_found

  def current_user
    @current_user ||= User.find(session[:current_user_id])
  rescue
    nil
  end
  helper_method :current_user

  def require_user!
    redirect_to new_session_path, warning: "You need to sign in!" unless current_user
  end

  def check_attr
    if !current_user.account_registered?
      redirect_to edit_profile_path, danger: "Please fill in your registration information below."
    elsif !current_user.valid_shirt_size?
      redirect_to edit_profile_path, danger: "Please update your shirt size."
    end
  end
end
