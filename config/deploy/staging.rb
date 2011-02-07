# STAGING-specific deployment configuration
# please put general deployment config in config/deploy.rb

set(:rake,        "/opt/ruby-enterprise/bin/rake")
set(:rails_env,   "staging")
set(:application, "cdx-online")
set(:repository,  "svn://curfew.jbpub.com/online/management/tags/#{ENV['TAG']}")
set(:deploy_to,   "/opt/deploy/#{application}")
set(:use_sudo,    false)
set(:user,        "deploy")


role(:app, "concave.jbpub.com")
role(:web, "concave.jbpub.com")
role(:db,  "concave.jbpub.com", :primary => true)


# Make sure we're using the correct database config file
after("deploy:update_code", :roles => :app) do
  # Make copies of the database and application configs
  run "cp #{release_path}/config/database-staging.yml #{release_path}/config/database.yml"
  run "cp #{release_path}/config/application-staging.yml #{release_path}/config/application.yml"

  # remove the production database.yml file from staging... for security reasons
  run "rm -rf #{release_path}/config/database-production.yml"

  # Make sure we link to the assets
  run "ln -s #{shared_path}/assets #{release_path}/public/assets"
end


# Touch a passenger. Go to jail.
namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
