source "https://rubygems.org"

# User authentication
gem "devise"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-twitter"
gem "activemerchant", github: "tomprats/active_merchant", branch: "fix-paypal-digital-goods-gateway"
gem "paypal-sdk-rest"
gem "pry"

# Testing
group :development, :test do
  gem "factory_girl"
  gem "rspec-rails"
  gem "shoulda-matchers"
end

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "4.0.0"

# Use postgresql as the database for Active Record
gem "pg"

# Heroku compatable assets
gem "rails_12factor", group: :production
gem "yui-compressor"

# Remaining assets
gem "sass-rails", "~> 4.0.0"
gem "bootstrap-sass"
gem "font-awesome-rails"
gem "pickadate-rails"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-datatables-rails", github: "rweng/jquery-datatables-rails"
gem "jquery-rails"

# Other
gem "traitify"
gem "prawn"
gem "prawn-table"

# Use ActiveModel has_secure_password
# gem "bcrypt-ruby", "~> 3.0.0"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

gem "mocha", group: :test
