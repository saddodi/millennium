set :application, "millennium"
set :repository,  "git@github.com:ghaydarov/millennium.git"
set :deploy_to, "~/var/www/#{application}"

set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "master"
set :user, "deploy"
role :web, "millennium.tranzsend.com"                          # Your HTTP server, Apache/etc
role :app, "millennium.tranzsend.com"                          # This may be the same as your `Web` server
role :db,  "millennium.tranzsend.com", :primary => true # This is where Rails migrations will run
default_run_options[:pty] = true

set :rake, "rake"
ENV['rvm_path']||="~/.rvm"
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"    
require "bundler/capistrano"
set :rvm_ruby_string, 'ruby-1.9.2-p290@millennium'        # Or whatever env you want it to run in.
set :rvm_type, :user  # Copy the exact line. I really mean :user here

# set :default_environment, {
#   'PATH' => "/path/to/.rvm/gems/ruby-1.9.2-p290/bin:/path/to/.rvm/bin:/path/to/.rvm/ruby-1.9.2-p290/bin:$PATH",
#   'RUBY_VERSION' => 'ruby-1.9.2-p290',
#   'GEM_HOME'     => '/path/to/.rvm/gems/ruby-1.9.2-p290',
#   'GEM_PATH'     => '/path/to/.rvm/gems/ruby-1.9.2-p290',
#   'BUNDLE_PATH'  => '/path/to/.rvm/gems/ruby-1.9.2-p290'  # If you are using bundler.
# }

# 

before "deploy:assets:precompile", "deploy:link_db"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :assets do
  task :precompile, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:precompile"
  end
  task :cleanup, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:clean"
  end
  
end

after :deploy, "assets:precompile"


# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end