class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!, except: [:show, :edit]
  before_filter :check_attr, :only => [:show]

  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def create
    begin
      params[:user][:birthday] = convert_birthday_to_date(params[:user][:birthday])
      super
      session[:omniauth] = nil unless @user.new_record?
    rescue ArgumentError
      flash[:alert] = "Please fill in all necessary fields correctly"
      redirect_to action: :new
    end
  end

  def show
    authentications
    @league = League.current
  end

  def register
    @registration = current_user.registration
    if @registration && @registration.not_registered? && @registration.paid? && @registration.update_attributes(registered: true)
      redirect_to :back, notice: "You've been successfully registered for #{@registration.league.name}"
    else
      redirect_to :back, alert: "Your registration could not go through"
    end
  end

  def unregister
    @registration = current_user.registration
    if @registration && @registration.registered? && @registration.update_attributes(registered: false)
      redirect_to :back, notice: "You've been successfully unregistered. You cannot be refunded, but you may register again for free"
    else
      redirect_to :back, alert: "You can not be unregistered. Please contact tom@tomprats.com if you feel you should be"
    end
  end

  def edit
    authentications
    if @password
      flash[:notice] ||= "Enter current password to save changes."
    else
      flash[:notice] ||= "You have not yet set a password.  Fill in the password fields to create one."
    end
    super
  end

  def update
    begin
      params[:user][:birthday] = convert_birthday_to_date(params[:user][:birthday])
      authentications
      super
    rescue ArgumentError
      flash[:alert] = "Please fill in all necessary fields correctly"
      redirect_to action: :edit
    end
  end

  private
  def convert_birthday_to_date(birthday)
    DateTime.strptime(birthday, "%m/%d/%Y").to_date
  end

  def authentications
    @user = current_user
    @facebook = current_user.authentications.where(provider: "facebook").first
    @twitter  = current_user.authentications.where(provider: "twitter").first
    @password = !current_user.encrypted_password.blank?
  end

  def check_attr
    if !current_user.account_registered?
      redirect_to edit_user_registration_path, alert: "Please fill in your registration information below."
    end
  end
end
