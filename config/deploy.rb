# Bundler bootstrap
require 'bundler/capistrano'

# main details
set :application, "jxrono.isotope11.com"
server "jxrono.isotope11.com", :web, :app, :db, :primary => true

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/opt/trinidad/jxrono"
set :user, "deployer"
set :group, "deployer"
set :use_sudo, false

# repo details
set :scm, :git
set :repository, "git://github.com/isotope11/xrono.git"
set :branch, "jruby"
set :git_enable_submodules, 1

set :default_environment,
  'PATH' => "/opt/jruby/bin:$PATH",
  'JSVC_ARGS_EXTRA' => "-user vagrant",
  'JRUBY_OPTS' => '--1.9'
set :bundle_dir, ""
set :bundle_flags, "--system --quiet"

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "/etc/init.d/trinidad start"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Symlink shared resources on each release"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/initializers/gmail.rb #{release_path}/config/initializers/gmail.rb"
  end
end

before 'deploy:assets:precompile', 'deploy:symlink_shared'
