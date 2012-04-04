set :application, "RailsGuides"
set :domain, "railschina.org"
set :use_sudo, false
set :user, "ruby"
set :version, "v3.2.2"
set :repository,  "./output"
set :scm, :none

 
role :web, domain
role :app, domain
role :db,  domain, :primary => true 

#set :deploy_path, "/var/www/public_html/"

set :deploy_to, "/home/#{user}/guides"
set :deploy_via, :copy

#if you have a special directory to deploy the html
#namespace :remote do
  #desc <<-DESC
    #you can modify the deploy_path to set a symlink to your nginx or apache
  #DESC
  #task :create_symlink, :roles => :web do
    #run "ln -s #{current_path} #{deploy_path}"
  #end
#end


namespace :local do
  task :generate_guides do
    print "generate the lastest guides"
    system "rake generate_guides_CN RAILS_VERSION=#{version}  "
  end
end

namespace :deploy do
  task :migrate do
  end
  task :finalize_update do
  end
  task :start do
  end
  task :stop do 
  end
  task :restart do
  end
end

#callbacks
#after 'deploy:setup', 'remote:create_symlink'
before 'deploy:setup', 'local:generate_guides'

