Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :twitter,
    Rails.application.secrets.twitter_key,
    Rails.application.secrets.twitter_secret
  )
  provider(
    :facebook,
    Rails.application.secrets.facebook_key,
    Rails.application.secrets.facebook_secret,
    scope: "email", info_fields: "email, first_name, last_name"
  )
end
