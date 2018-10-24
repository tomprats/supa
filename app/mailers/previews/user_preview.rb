class UserPreview < ApplicationPreview
  def championship
    UserMailer.championship(user)
  end

  def invite
    UserMailer.invite(user)
  end

  def reset_password
    UserMailer.reset_password(user)
  end
end
