class EmailMailer < ApplicationMailer
  def email(user_id, email_id)
    @email = Email.find(email_id)
    @user = User.find(user_id)
    @html = @email.body_html

    mail(to: @user.email, subject: @email.subject)
  end
end
