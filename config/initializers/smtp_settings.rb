ActionMailer::Base.smtp_settings = {
  address: "email-smtp.us-east-1.amazonaws.com",
  port:                 "587",
  domain:               "tomify.me",
  user_name:            ENV["SMTP_USERNAME"],
  password:             ENV["SMTP_PASSWORD"],
  authentication:       "plain",
  enable_starttls_auto: true
}
