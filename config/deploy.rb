require "bundler/capistrano"
require 'capistrano/ext/multistage'
require 'haml'

set :stages, %w(staging production)

set :default_stage, "staging"

set :rake,           "bundle exec rake"

def render(file,opts={})
  template = File.read(file)
  haml_engine = Haml::Engine.new(template)
  output = haml_engine.render(nil,opts)
  output
end

#############################################################
#  Maintenance mode
#############################################################
task :disable_web, :roles => :web do
  on_rollback { delete "#{shared_path}/system/maintenance.html" }

  maintenance = render("./app/views/layouts/maintenance.haml",
                       {
                         :back_up => ENV['BACKUP'],
                         :reason => ENV['REASON'],
                         :message => ENV['MESSAGE']
                       })

  run "mkdir -p #{shared_path}/system/"
  put maintenance, "#{shared_path}/system/maintenance.html",
                   :mode => 0644
end
task :enable_web, :roles => :web do
  run "rm #{shared_path}/system/maintenance.html"
end

#############################################################
#  Application
#############################################################

set :application, "rites"
set :deploy_to, "/web/rites.concord.org"

#############################################################
#  Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:compression] = false
set :use_sudo, true
set :scm_verbose, true
set :rails_env, "production"

set :user, "deploy"

#############################################################
#  Git
#############################################################

set :scm, :git
set :branch, "production"
set :git_enable_submodules, 1
# wondering if we can do something special for this? create
# a special deploy user on github?
set(:scm_user) do
  Capistrano::CLI.ui.ask "Enter your git username: "
end
set(:scm_passphrase) do
  Capistrano::CLI.password_prompt( "Enter your git password: ")
end
set :repository, "git://github.com/concord-consortium/smartgraphs-authoring.git"
set :deploy_via, :remote_cache

#############################################################
#  DB
#############################################################

namespace :db do
  desc 'Dumps the production database to db/production_data.sql on the remote server'
  task :remote_db_dump, :roles => :db, :only => { :primary => true } do
    run "cd #{deploy_to}/#{current_dir} && " +
      "bundle exec rake RAILS_ENV=#{rails_env} db:dump --trace"
  end

  desc 'Loads the production database in db/production_data.sql on the remote server'
  task :remote_db_load, :roles => :db, :only => { :primary => true } do
    run "cd #{deploy_to}/#{current_dir} && " +
      "bundle exec rake RAILS_ENV=#{rails_env} db:load --trace"
  end

  desc '[NOTE: use "fetch_remote_db" instead!] Downloads db/production_data.sql from the remote production environment to your local machine'
  task :remote_db_download, :roles => :db, :only => { :primary => true } do
    remote_db_compress
    ssh_compression = ssh_options[:compression]
    ssh_options[:compression] = true
    download("#{deploy_to}/#{current_dir}/db/production_data.sql.gz", "db/production_data.sql.gz", :via => :scp)
    ssh_options[:compression] = ssh_compression
  end

  desc '[NOTE: use "push_remote_db" instead!] Uploads db/production_data.sql to the remote production environment from your local machine'
  task :remote_db_upload, :roles => :db, :only => { :primary => true } do
    ssh_compression = ssh_options[:compression]
    ssh_options[:compression] = true
    `gzip -f db/production_data.sql` unless File.exists?("db/production_data.sql.gz")
    upload("db/production_data.sql.gz", "#{deploy_to}/#{current_dir}/db/production_data.sql.gz", :via => :scp)
    ssh_options[:compression] = ssh_compression
    remote_db_uncompress
  end

  task :remote_db_compress, :roles => :db, :only => { :primary => true } do
    run "gzip -f #{deploy_to}/#{current_dir}/db/production_data.sql"
  end

  task :remote_db_uncompress, :roles => :db, :only => { :primary => true } do
    run "gunzip -f #{deploy_to}/#{current_dir}/db/production_data.sql.gz"
  end

  desc 'Cleans up data dump file'
  task :remote_db_cleanup, :roles => :db, :only => { :primary => true } do
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.remove "#{deploy_to}/#{current_dir}/db/production_data.sql"
        tsftp.remove "#{deploy_to}/#{current_dir}/db/production_data.sql.gz"
      end
    end
  end

  desc 'Dumps, downloads and then cleans up the production data dump'
  task :fetch_remote_db do
    remote_db_dump
    remote_db_download
    remote_db_cleanup
  end

  desc 'Uploads, inserts, and then cleans up the production data dump'
  task :push_remote_db do
    remote_db_upload
    remote_db_load
    remote_db_cleanup
  end

  desc 'Copies config/initializers/site_keys.rb from the remote environment to your local machine'
  task :fetch_remote_site_keys, :roles => :app do
    download("#{deploy_to}/shared/config/initializers/site_keys.rb", "config/initializers/site_keys.rb", :via => :sftp)
  end

  desc 'Copies config/initializers/site_keys.rb from the remote environment to your local machine'
  task :push_local_site_keys, :roles => :app do
    upload("config/initializers/site_keys.rb", "#{deploy_to}/shared/config/initializers/site_keys.rb", :via => :sftp)
  end

  desc "Pulls uploaded attachments from the remote server"
  task :fetch_remote_attachments, :roles => :web do
    remote_dir  = "#{shared_path}/system/attachments/"
    local_dir   = "public/system/attachments/"
    run_locally "rsync -avx --delete #{fetch(:user)}@#{domain}:#{remote_dir} #{local_dir}"
  end

  desc "Pushes uploaded attachments to the remote server"
  task :push_local_attachments, :roles => :web do
    remote_dir  = "#{shared_path}/system/attachments/"
    local_dir   = "public/system/attachments/"
    run_locally "rsync -avx --delete #{local_dir} #{fetch(:user)}@#{domain}:#{remote_dir}"
  end

end

namespace :deploy do
  # By default deploy:cleanup uses sudo(!)
  # We don't want this when using a deploy user
  set :use_sudo, false

  #############################################################
  #  Passenger
  #############################################################

  # Restart passenger on deploy
  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end

  desc "setup directory remote directory structure"
  task :make_directory_structure do
    run "mkdir -p #{deploy_to}/releases"
    run "mkdir -p #{shared_path}"
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/log"
    run "mkdir -p #{shared_path}/rinet_data"
    run "mkdir -p #{shared_path}/config/nces_data"
    run "mkdir -p #{shared_path}/public/otrunk-examples"
    run "mkdir -p #{shared_path}/public/sparks-content"
    run "mkdir -p #{shared_path}/public/installers"
    run "mkdir -p #{shared_path}/config/initializers"
    run "mkdir -p #{shared_path}/system/attachments" # paperclip file attachment location
    run "touch #{shared_path}/config/database.yml"
    run "touch #{shared_path}/config/settings.yml"
    run "touch #{shared_path}/config/installer.yml"
    run "touch #{shared_path}/config/rinet_data.yml"
    run "touch #{shared_path}/config/mailer.yml"
    run "touch #{shared_path}/config/initializers/site_keys.rb"
    run "touch #{shared_path}/config/initializers/subdirectory.rb"
    run "touch #{shared_path}/config/database.yml"

    # support for running a SproutCore app from within the public directory
    run "mkdir -p #{shared_path}/public/static"
    run "mkdir -p #{shared_path}/public/labels"
  end

  desc "link in some shared resources, such as database.yml"
  task :shared_symlinks do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
    run "ln -nfs #{shared_path}/config/installer.yml #{release_path}/config/installer.yml"
    run "ln -nfs #{shared_path}/config/rinet_data.yml #{release_path}/config/rinet_data.yml"
    run "ln -nfs #{shared_path}/config/mailer.yml #{release_path}/config/mailer.yml"
    run "ln -nfs #{shared_path}/config/initializers/site_keys.rb #{release_path}/config/initializers/site_keys.rb"
    run "ln -nfs #{shared_path}/config/initializers/subdirectory.rb #{release_path}/config/initializers/subdirectory.rb"
    run "ln -nfs #{shared_path}/public/otrunk-examples #{release_path}/public/otrunk-examples"
    run "ln -nfs #{shared_path}/public/sparks-content #{release_path}/public/sparks-content"
    run "ln -nfs #{shared_path}/public/installers #{release_path}/public/installers"
    run "ln -nfs #{shared_path}/config/nces_data #{release_path}/config/nces_data"
    run "ln -nfs #{shared_path}/rinet_data #{release_path}/rinet_data"
    run "ln -nfs #{shared_path}/system #{release_path}/public/system" # paperclip file attachment location
    # This is part of the setup necessary for using newrelics reporting gem
    # run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml"
    run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml"

    # support for running SproutCore app from the public directory
    run "ln -nfs #{shared_path}/public/static #{release_path}/public/static"
    run "cd #{release_path}/public; for i in `ls #{shared_path}/public/labels`; do rm $i; ln -s #{shared_path}/public/labels/$i $i; done"
  end

  desc "install required gems for application"
  task :install_gems do
    sudo "sh -c 'cd #{deploy_to}/current; bundle exec rake gems:install'"
  end

end


#
# generake (hehe) cap task to run rake tasks.
# found here: http://stackoverflow.com/questions/312214/how-do-i-run-a-rake-task-from-capistrano
namespace :rake_tasks do  
  desc "Run a rake task: cap staging rake:invoke task=a_certain_task"
  # run like: cap staging rake:invoke task=a_certain_task  
  task :invoke do  
    run("cd #{deploy_to}/current; bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
 rake #{ENV['task']} RAILS_ENV=#{rails_env}")  
  end  
end

namespace :hobo do
  desc 'invoke the generate_taglibs rake task'
  task :generate_taglibs do
    run("cd #{deploy_to}/current; bundle exec rake hobo:generate_taglibs RAILS_ENV=#{rails_env}")
  end
end

namespace :converter do
  desc 'install the smartgraph-generator node package and convert binary'
  task :install do
    run("cd #{deploy_to}/current; npm install")
  end
end

before 'deploy:update_code', 'deploy:make_directory_structure'
after 'deploy:update_code', 'converter:install'
after 'deploy:update_code', 'deploy:shared_symlinks'
before 'deploy:restart', 'hobo:generate_taglibs'
after 'deploy:migrate', 'hobo:generate_taglibs'
