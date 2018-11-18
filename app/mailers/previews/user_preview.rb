class UserPreview < ApplicationPreview
  def reset_password
    UserMailer.reset_password(user)
  end
end
