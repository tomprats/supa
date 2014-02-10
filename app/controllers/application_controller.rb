class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_filter :check_attr
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def signed_in_root_path(resource_or_scope)
    profile_path
  end

  def check_attr
    if !devise_controller?
      if !current_user.account_registered?
        redirect_to edit_user_registration_path, :alert => "Please fill in your registration information below."
      end
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:birthday,
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
    devise_parameter_sanitizer.for(:sign_up)        { |u| u.permit(:birthday,
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
