class SubscriptionsController < ApplicationController
  skip_before_action :require_user!, only: [:new, :create, :destroy]
  skip_before_action :check_attr

  def create
    if current_user.update(unsubscribed: false)
      redirect_back success: "Yay, you subscribed!"
    else
      redirect_back warning: "There was a problem subscribing: #{@user.errors.full_messages.join(", ")}"
    end
  end

  def destroy
    if current_user.update(unsubscribed: true)
      redirect_back success: "Aw man, you unsubscribed!"
    else
      redirect_back warning: "There was a problem unsubscribing: #{@user.errors.full_messages.join(", ")}"
    end
  end
end
