class UserPreview < ActionMailer::Preview
  def championship
    UserMailer.championship(user)
  end

  def invite
    UserMailer.invite(user)
  end

  def reset_password
    UserMailer.reset_password(user)
  end

  private
  def user
    User.tom
  end
end
