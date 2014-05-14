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
      redirect_to @gateway.redirect_url_for(setup_response.token, mobile: mobile_device?)
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
        redirect_to profile_path, alert: "Paypal payment was unsuccessful. Try again or email tom@stewartstownupa.com to troubleshoot with you"
      end
    else
      redirect_to profile_path, alert: "Paypal payment was unsuccessful. Try again or email tom@stewartstownupa.com to troubleshoot with you"
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
      @payment.update_attributes(notify_response: notify.params.to_s)
    end
  end

  # Through Admin
  def cash
    @user = User.find(params[:user_id])
    @league = League.find(params[:league_id])
    @registration = @user.registrations.where(league_id: @league.id).first
    @registration ||= @user.registrations.create(league_id: @league.id)
    @payment = @registration.payment || @registration.create_payment
    if @payment.paid?
      redirect_to :back, alert: "They have already paid"
    elsif @league.price.zero?
      @payment.update_attributes(paid: true)
      redirect_to :back, notice: "This league is free!"
    else
      @payment.update_attributes(
        paid: true,
        purchase_response: "Cash",
        notify_response: current_user.id
      )
      redirect_to :back, notice: "Cash payment successful. They are still unregistered until they click register"
    end
  end

  # Through API
  def credit_card
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
      @paypal = setup_sdk_purchase(
        @league.price,
        "#{@league.name} Registration",
        "Stewartstown Ultimate Players Association registration for #{@league.name}.",
        credit_card_params
      )
      if @paypal.create
        @payment.update_attributes(
          paid: true,
          token: @paypal.id,
          transaction_id: @paypal.transactions.first.related_resources.first.sale.id,
          purchase_response: @paypal.to_hash.to_s
        )
        redirect_to profile_path, notice: "Credit card payment successful. You are still unregistered until you click register"
      else
        @payment.update_attributes(purchase_response: @paypal.to_hash.to_s, notify_response: @paypal.error.to_s)
        redirect_to profile_path, alert: "Credit card payment was unsuccessful. Try again or email tom@stewartstownupa.com to troubleshoot with you"
      end
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

  def credit_card_params
    params.require(:credit_card).permit(
      :type,
      :number,
      :expire_month,
      :expire_year,
      :cvv2,
      :first_name,
      :last_name,
      billing_address: [
        :line1,
        :city,
        :state,
        :postal_code,
        :country_code
      ]
    )
  end
end
