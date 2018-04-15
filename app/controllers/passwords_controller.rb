class PasswordsController < ApplicationController
  skip_before_action :require_user!, :check_attr

  def create
    if user = User.find_by(email: params[:email])
      UserMailer.reset_password(user).deliver_now
      redirect_back success: "Email Sent!"
    else
      render :new, warning: "Email Not Found"
    end
  end

  def update
    user = User.joins(:tokens).find_by(tokens: { uuid: params[:token] })

    if user.update(password_params)
      session[:current_user_id] = user.id
      redirect_to profile_path, success: "Password Updated!"
    else
      redirect_back warning: user.errors.full_messages.join(", ")
    end
  end

  private
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
