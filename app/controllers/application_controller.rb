class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_filter :check_attr
  before_filter :configure_permitted_parameters, if: :devise_controller?

  helper_method :paypal_url, :mobile_device?

  def signed_in_root_path(resource_or_scope)
    profile_path
  end

  def check_attr
    unless devise_controller?
      if !current_user.account_registered?
        redirect_to edit_user_registration_path, alert: "Please fill in your registration information below."
      elsif !current_user.valid_shirt_size?
        redirect_to edit_user_registration_path, alert: "Please update your shirt size."
      end
    end
  end

  def mobile_device?
    !!(request.user_agent =~ /android|blackberry|iphone|ipad|ipod|iemobile|mobile|webos/i)
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(
      :birthday,
      :gender,
      :phone_number,
      :shirt_size,
      :experience,
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :current_password
    ) }
    devise_parameter_sanitizer.for(:sign_up)        { |u| u.permit(
      :birthday,
      :gender,
      :phone_number,
      :shirt_size,
      :experience,
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    ) }
  end
end
