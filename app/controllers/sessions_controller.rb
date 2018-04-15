class SessionsController < ApplicationController
  skip_before_action :require_user!, :check_attr

  def new
    @user = User.new
  end

  def create
    email = params[:user][:email].strip.downcase
    user = User.find_by(email: email)
    if user && user.password_digest && user.authenticate(params[:user][:password])
      session[:current_user_id] = user.id
      redirect_to profile_path
    else
      @user = User.new(email: email)
      render :new, warning: "Invalid email/password combination"
    end
  end

  def reset_password
    if user = User.find_by(email: params[:email])
      UserMailer.reset_password_email(user).deliver_now
      redirect_to root_path, success: "Email Sent"
    else
      redirect_back danger: "Email could not be found"
    end
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to root_path
  end
end
