class UsersController < ApplicationController
  skip_before_filter :require_user!, only: [:new, :create]
  skip_before_filter :check_attr
  before_filter :set_variables, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:current_user_id] = @user.id
      redirect_to profile_path, success: "Signed Up!"
    else
      render "sessions/new", warning: @user.errors.full_messages.join(", ")
    end
  end

  def update
    @user.assign_attributes(user_params)

    require_current_password = @user.email_changed? || @user.password.present?
    if require_current_password && !@user.authenticate(params[:user][:current_password])
      return render :edit, warning: "Must enter current password to update email/password"
    end

    if @user.save
      redirect_to :back, success: "Profile Updated!"
    else
      render :edit, warning: @user.errors.full_messages.join(", ")
    end
  end

  private
  def user_params
    params[:user][:birthday] = DateTime.strptime(params[:user][:birthday], "%m/%d/%Y").to_date rescue nil
    params.require(:user).permit(
      :email, :experience, :first_name,
      :gender, :image, :last_name,
      :password, :password_confirmation,
      :phone_number, :post_notifications,
      :shirt_size
    )
  end

  def set_variables
    @league = League.current
    @user = current_user
    @facebook = current_user.authentications.find_by(provider: "facebook")
    @twitter  = current_user.authentications.find_by(provider: "twitter")
    @password = current_user.password_digest.present?
  end
end
