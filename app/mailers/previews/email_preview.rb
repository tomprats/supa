class EmailPreview < ApplicationPreview
  def email
    EmailMailer.email(user.id, Email.first.id)
  end
end
