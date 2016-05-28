class UserMailer < ApplicationMailer
  def registration_email(user)
    @user = user

    mail(to: @user.email, subject: "SUPA - Summer League Registration!")
  end
end
