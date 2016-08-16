class PaymentsController < ApplicationController
  before_action :check_admin_level, only: :cash
  before_action :set_payment

  def cash
    @payment.update_attributes(
      paid: true,
      purchase_response: "Cash",
      notify_response: current_user.id
    )
    redirect_to :back, success: "Cash payment successful. They are still unregistered until they click register"
  end

  def credit_card
    charge = Stripe::Charge.create(
      source: params[:stripe_token],
      amount: (@league.current_price*100).round,
      currency: "usd",
      description: "#{current_user.name} (#{current_user.email}) registration for #{@league.name}"
    )

    @payment.update_attributes(paid: true, token: charge.id)

    redirect_to profile_path, success: "Credit card payment successful. You are still unregistered until you click register"
  rescue => e
    Rails.logger.error e
    redirect_to :back, alert: "Credit card payment was unsuccessful. Try again or email tom@stewartstownupa.com to troubleshoot with you"
  end

  private
  def check_admin_level
    unless current_user.is_super_admin?
      redirect_to profile_path, success: "You are not authorized to be there!"
    end
  end

  def set_payment
    user = action_name == "cash" ? User.find(params[:user_id]) : current_user
    @league = League.find(params[:league_id])
    @registration = user.registrations.where(league_id: @league.id).first
    @registration ||= user.registrations.create(league_id: @league.id)
    @payment = @registration.payment || @registration.create_payment
    if @payment.paid?
      return redirect_to :back, alert: "#{action_name == "cash" ? "They" : "You"} have already paid"
    elsif @league.current_price.zero?
      @payment.update_attributes(paid: true)
      return redirect_to :back, success: "This league is free!"
    end
  end
end
