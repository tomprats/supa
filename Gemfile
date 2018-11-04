source "https://rubygems.org"

ruby "2.5.0"

gem "rails"
gem "pg"
gem "unicorn"
gem "sidekiq"

# User authentication
gem "bcrypt"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-twitter"

# Testing
group :development, :test do
  gem "factory_bot"
  gem "rspec-rails"
  gem "shoulda-matchers"
end

# Remaining assets
gem "carrierwave"
gem "fog-aws"
gem "sass"
gem "sass-rails"
gem "bootstrap-sass"
gem "font-awesome-rails"
gem "pickadate-rails"
gem "uglifier"
gem "coffee-rails"
gem "jquery-datatables-rails"
gem "jquery-rails"
gem "haml"

# Other
gem "stripe"
gem "traitify"
gem "prawn"
gem "prawn-table"
gem "redcarpet"

group :development do
  gem "capistrano-postgresql"
  gem "capistrano-rails"
  gem "capistrano-rails-collection"
  gem "capistrano-rvm"
  gem "capistrano-secrets-yml"
  gem "capistrano-unicorn-nginx", github: "capistrano-plugins/capistrano-unicorn-nginx", branch: "systemd"

  gem "better_errors"
  gem "binding_of_caller"
  gem "pry"
end
