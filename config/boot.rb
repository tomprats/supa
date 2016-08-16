ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

### Begin Monkey Patch ###
require "rails/commands/server"

module Rails
  class Server
    alias :default_options_old :default_options
    def default_options
      default_options_old.merge!(Host: "0.0.0.0")
    end
  end
end
### End Monkey Patch ###

require 'bundler/setup' # Set up gems listed in the Gemfile.
