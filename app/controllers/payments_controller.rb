class PaymentsController < ApplicationController
  protect_from_forgery except: :notify

  before_filter :assigns_gateway
  skip_before_filter :authenticate_user!, only: [:notify]
  skip_before_filter :check_attr, only: [:notify]

  include ActiveMerchant::Billing
  include PaypalPaymentsHelper

  def checkout
    @league = League.find(params[:league_id])
    @registration = current_user.registrations.where(league_id: @league.id).first
    @registration ||= current_user.registrations.create(league_id: @league.id)
    @payment = @registration.payment || @registration.create_payment

    if @payment.paid?
      redirect_to :back, alert: "You have already paid"
    elsif @league.price.zero?
      @payment.update_attributes(paid: true)
      redirect_to :back, notice: "This league is free!"
    else
      price, setup_purchase_params = get_setup_purchase_params(
        @league.price,
        "#{@league.name} Registration",
        "Stewartstown Ultimate Players Association registration for #{@league.name}.",
        request.remote_ip
      )
      setup_response = @gateway.setup_purchase(price, setup_purchase_params)
      @payment.update_attributes(token: setup_response.token, setup_response: setup_response.params.to_s)
      redirect_to @gateway.redirect_url_for(setup_response.token)
    end
  end

  def success
    @payment = Payment.where(token: params[:token]).first
    if @payment && params[:PayerID]
      @payment.update_attributes(payer_id: params[:PayerID])
      price, purchase_params = get_purchase_params(@payment)
      purchase_response = @gateway.purchase(price, purchase_params)
      if purchase_response.params["payment_status"] == "Completed"
        @payment.update_attributes(paid: true, transaction_id: purchase_response.params["transaction_id"], purchase_response: purchase_response.params.to_s)
        redirect_to profile_path, notice: "Paypal payment successful. You are still unregistered until you click register"
      else
        @payment.update_attributes(purchase_response: purchase_response)
        redirect_to profile_path, alert: "Paypal payment was unsuccessful. Try again or email supa@tomprats.com to trouble shoot with you"
      end
    else
      redirect_to profile_path, alert: "Paypal payment was unsuccessful. Try again or email supa@tomprats.com to trouble shoot with you"
    end
  end

  def cancel
    redirect_to profile_path, alert: "Paypal payment was canceled"
  end

  def notify
    notify = Integrations::Paypal::Notification.new(request.raw_post)
    render nothing: true
    @payment = Payment.where(transaction_id: notify.transaction_id).first
    if @payment && notify.params["payment_status"] == "Completed"
      @payment.update_attributes(paid: true, notify_response: notify.params.to_s)
    elsif @payment
      @payment.update_attributes(paid: false, notify_response: notify.params.to_s)
    end
  end

  private
  def assigns_gateway
    @gateway ||= PaypalDigitalGoodsGateway.new(
      login:     ENV["PAYPAL_USERNAME"],
      password:  ENV["PAYPAL_PASSWORD"],
      signature: ENV["PAYPAL_SIGNATURE"]
    )
  end
end
