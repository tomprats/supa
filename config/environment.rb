require_relative "application"

# Load local ENV vars
local_env = File.join(Rails.root, 'config', 'local_variables.rb')
load(local_env) if File.exists?(local_env)

# Initialize the Rails application.
Rails.application.initialize!
