class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!, :except => [:show, :edit]

  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def create
    params[:user][:birthday] = convert_birthday_to_date(params[:user][:birthday])
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  def show
    authentications
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
    params[:user][:birthday] = convert_birthday_to_date(params[:user][:birthday])
    authentications
    super
  end

  private
  def convert_birthday_to_date(birthday)
    puts birthday
    DateTime.strptime(birthday, "%m/%d/%Y").to_date
  end

  def authentications
    @user = current_user
    @facebook = current_user.authentications.where(:provider => "facebook").first
    @twitter  = current_user.authentications.where(:provider => "twitter").first
    @password = !current_user.encrypted_password.blank?
  end
end
