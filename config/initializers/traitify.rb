Traitify.configure do |traitify|
  traitify.version = "v1"
  traitify.host = Rails.application.secrets.traitify_host
  traitify.public_key = Rails.application.secrets.traitify_public
  traitify.secret_key = Rails.application.secrets.traitify_secret
  traitify.deck_id = "core"
end
