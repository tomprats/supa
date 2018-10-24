require "capistrano/setup"
require "capistrano/deploy"

require "capistrano/bundler"
require "capistrano/postgresql"
require "capistrano/rails/assets"
require "capistrano/rails/collection"
require "capistrano/rails/migrations"
require "capistrano/rvm"
require "capistrano/secrets_yml"
require "capistrano/sidekiq"
require "capistrano/unicorn_nginx"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
