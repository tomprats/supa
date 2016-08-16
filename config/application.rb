require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Supa
  class Application < Rails::Application
    config.time_zone = "Eastern Time (US & Canada)"

    config.assets.paths << "#{Rails.root}/app/assets/html"
    config.assets.precompile += %w(404.html 500.html)

    my_date_formats = { :default => '%m/%d/%Y' }
    Time::DATE_FORMATS.merge!(my_date_formats)
    Date::DATE_FORMATS.merge!(my_date_formats)
  end
end
