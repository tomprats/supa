class UserMailer < ApplicationMailer
  def invite(user)
    @user = user

    mail(to: @user.email, subject: "SUPA - Summer League Registration!")
  end

  def reset_password(user)
    @user = user

    mail(to: @user.email, subject: "SUPA - Reset Password")
  end
end
