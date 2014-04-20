module PaypalPaymentsHelper
  def get_setup_purchase_params(price, name, description, ip)
    return to_cents(price), {
      ip: ip,
      return_url: payments_success_url,
      notify_url: payments_notify_url,
      cancel_return_url: payments_cancel_url,
      no_shipping: 0,
      items: [{
        name: name,
        number: 1,
        quantity: 1,
        category: "Digital",
        description: description,
        amount: to_cents(price)
      }]
    }
  end

  def get_purchase_params(payment)
    return to_cents(payment.price), {
      token: payment.token,
      payer_id: payment.payer_id
    }
  end

  def to_cents(money)
    (money*100).round
  end
end
