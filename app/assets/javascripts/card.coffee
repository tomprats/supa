$ ->
  $(document).on "submit", "#credit-card-form", (e) ->
    e.preventDefault()
    $form = $(this)
    $error = $form.find(".error")
    $errorContainer = $error.closest(".form-group")
    $errorContainer.addClass("hide")
    Stripe.card.createToken {
      name: $form.find("#stripe_card_name").val(),
      number: $form.find("#stripe_card_number").val(),
      exp: $form.find("#stripe_card_exp").val(),
      cvc: $form.find("#stripe_card_cvc").val(),
    }, (status, response) ->
      if response.error
        $error.text(response.error.message)
        $errorContainer.removeClass("hide")
      else
        $cardForm = $("#stripe-token-form")
        $cardForm.find("#stripe_token").val(response.id)
        $cardForm[0].submit()
