class UserPreview < ActionMailer::Preview
  def invite
    UserMailer.registration_email(user)
  end

  private
  def user
    User.find_by(email: "tprats108@gmail.com")
  end
end
