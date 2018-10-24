class EmailJob < ApplicationJob
  def perform(email_id, preview: true)
    users = preview ? User.super : User.all
    # TODO: Remove
    tom = User.tom
    users.find_each.with_index do |user, index|
      EmailMailer.email(tom.id, email_id).deliver_later(wait: (index * 10).seconds + 1.minute)
    end
  end
end
