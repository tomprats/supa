class UserMailer < ApplicationMailer
  def championship(user)
    @user = user

    mail(to: @user.email, subject: "SUPA - Championship Game!")
  end

  def invite(user)
    @user = user

    mail(to: @user.email, subject: "SUPA - Summer League Registration Ending!")
  end

  def reset_password(user)
    @user = user

    mail(to: @user.email, subject: "SUPA - Reset Password")
  end
end
