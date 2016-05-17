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

  def setup_sdk_purchase(price, name, description, credit_card)
    PayPal::SDK.configure(
      mode: ENV["PAYPAL_SDK_MODE"],
      client_id: ENV["PAYPAL_SDK_ID"],
      client_secret: ENV["PAYPAL_SDK_SECRET"]
    )

    # Build Payment object
    PayPal::SDK::REST::Payment.new({
      intent: "sale",
      payer: {
        payment_method: "credit_card",
        funding_instruments: [{
          credit_card: credit_card
        }]
      },
      transactions: [{
        item_list: {
          items: [{
            name: name,
            sku: name,
            price: price.to_i,
            currency: "USD",
            quantity: 1
          }]
        },
        amount: {
          total: price.to_i,
          currency: "USD"
        },
        description: description
      }]
    })
  end
end
