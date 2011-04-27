set :stage, "dev" unless variables[:stage]
set :username, "rdeploy"
set :application, "dev.accounts.ayopasoft.com"
set :repository,  "svn+ssh://#{username}@office.happyjacksoftware.com/usr/local/svn_repo/Ayopa_Rails/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/usr/local/rails/#{application}"
set :deploy_via, :export

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion                           
case stage
when "dev"
  set :user, username
  role :app, "dev.accounts.ayopasoft.com"
  role :web, "dev.accounts.ayopasoft.com"
  role :db,  "dev.accounts.ayopasoft.com", :primary => true 
  set :run_method, :sudo  
  set :rails_env, "development"
when "prod"
  set :user, username
  role :app, "accounts.ayopasoft.com"
  role :web, "accounts.ayopasoft.com"
  role :db,  "accounts.ayopasoft.com", :primary => true  
  set :run_method, :run 
else
  raise "Unsupported staging environment: #{stage}"
end

desc "Symlink the database config file from shared directory to current release directory."
task :symlink_database_yml do
  run "ln -nsf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

desc "Symlink the specific files from shared directory to current release directory."
task :symlink_specifics do
  run "ln -nsf #{shared_path}/public/ayopa_static #{release_path}/public/ayopa_static"

end

after "deploy:update_code", "symlink_database_yml", "symlink_specifics"

namespace(:deploy) do
  desc "Restart server"
  task :restart do    
    case stage
    when "prod"
      run "touch #{release_path}/tmp/restart.txt"
    when "dev"
      sudo "/sbin/service httpd stop"
      sudo "/sbin/service httpd start"
    else
      raise "Unsopported staging environment: #{stage}"
    end
  end
end
