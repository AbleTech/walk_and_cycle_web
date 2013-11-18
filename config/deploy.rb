set :stages, %w(www staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "journeyplanner-frontend"
set :user, "deploy"
set :group, "deploy"
set :use_sudo, false

role :web, "50.23.86.195"
role :app, "50.23.86.195"

set :scm, :git
set :repository, "git@github.com:AbleTech/walk_and_cycle_web.git"
set :deploy_via, :remote_cache
set :branch, "master"
