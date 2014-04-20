# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Load local ENV vars
local_env = File.join(Rails.root, 'config', 'local_variables.rb')
load(local_env) if File.exists?(local_env)

# Initialize the Rails application.
Supa::Application.initialize!
