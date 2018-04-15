class RegistrationsController < ApplicationController
  def create
    @registration = current_user.registration
    if @registration && @registration.not_registered? && @registration.paid? && @registration.update_attributes(registered: true)
      redirect_back success: "You've been successfully registered for #{@registration.league.name}"
    else
      redirect_back alert: "Your registration could not go through"
    end
  end

  def destroy
    @registration = current_user.registration
    if @registration && @registration.registered? && @registration.update_attributes(registered: false)
      redirect_back success: "You've been successfully unregistered. You cannot be refunded, but you may register again for free"
    else
      redirect_back alert: "You can not be unregistered. Please contact tom@tomprats.com if you feel you should be"
    end
  end
end
