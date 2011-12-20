require 'mongrel_cluster/recipes'

set :application, "ptls"
default_run_options[:pty] = true
set :repository,  "git@github.com:yfactorial/#{application}.git"
set :branch, "master"
set :domain, "labs.yfactorial.com"

# set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :deploy_via, :copy
# set :copy_cache, true
set :copy_exclude, [".git"]
set :deploy_to, "/var/www/apps/#{application}"
set :mongrel_conf, "/etc/mongrel_cluster/ptls.yml"
set :db_conf, "/etc/ptls/database.yml"
set :scm, "git"
set :user, 'deploy'
set :use_sudo, false

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# Callbacks
after "deploy:update_code", "deploy:link_configs"

namespace :deploy do

  # Override default restart task
  desc "Restart #{application} mongrels"
  task :restart, :roles => :app do
    invoke_command "cd #{current_path} && mongrel_rails cluster::restart --config #{mongrel_conf} --clean"
  end
  
  task :link_configs, :roles => :app do  
    run "ln -nfs #{db_conf} #{release_path}/config/database.yml"
  end
  
end
