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

  def destroy
    session[:current_user_id] = nil
    redirect_to root_path
  end
end
