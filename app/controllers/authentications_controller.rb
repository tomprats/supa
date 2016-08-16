class AuthenticationsController < ApplicationController
  skip_before_filter :require_user!, :check_attr, only: :create

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    if current_user.authentications.count > 1 || !current_user.encrypted_password.blank?
      @authentication.destroy
      redirect_to :back, success: "Successfully destroyed authentication."
    else
      redirect_to :back, alert: "You must have at least 1 method of authentication (password, facebook, twitter...)."
    end
  end

  def create
    authenticate_with_provider
  end

  private
  def authentication_params
    params.require(:authentication).permit(:user_id, :provider, :uid)
  end

  def authenticate_with_provider
    omni = request.env["omniauth.auth"]

    authentication = Authentication.find_by_provider_and_uid(omni["provider"], omni["uid"])

    if authentication
      session[:current_user_id] = authentication.user_id
      redirect_to profile_path, success: "Logged in Successfully"
    elsif current_user
      token = omni["credentials"].token
      token_secret = omni["credentials"].secret

      current_user.authentications.create!(provider: omni["provider"], uid: omni["uid"], token: token, token_secret: token_secret)
      redirect_to profile_path, success: "Authentication successful."
    else
      user = User.new
      if omni["provider"] == "facebook"
        user.email = omni["extra"]["raw_info"].email
        user.first_name = omni["info"].first_name
        user.last_name  = omni["info"].last_name
        user.gender     = omni["extra"]["raw_info"].gender
        if omni["extra"]["raw_info"].birthday
          user.birthday   = Date.strptime(omni["extra"]["raw_info"].birthday, "%m/%d/%Y")
        end
      end

      user.authentications.build(
        provider:     omni["provider"],
        uid:          omni["uid"],
        token:        omni["credentials"].token,
        token_secret: omni["credentials"].secret
      )

      if user.save
        session[:current_user_id] = user.id
        redirect_to profile_path, success: "Logged in."
      else
        session[:omniauth] = omni.except("extra")
        redirect_to new_user_registration_path
      end
    end
  end
end
