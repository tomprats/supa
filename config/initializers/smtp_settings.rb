ActionMailer::Base.smtp_settings = {
  address: "email-smtp.us-east-1.amazonaws.com",
  port:                 "587",
  domain:               "tomify.me",
  user_name:            Rails.application.secrets.smtp_username,
  password:             Rails.application.secrets.smtp_password,
  authentication:       "plain",
  enable_starttls_auto: true
}
