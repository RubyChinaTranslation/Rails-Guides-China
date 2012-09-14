set :application, "Rails Guides"
set :domain, "guides.ruby-china.org"
set :use_sudo, false
set :user, "ruby"
set :repository,  "./output"
set :scm, :none

 
role :web, domain
role :app, domain
role :db,  domain, :primary => true 

set :deploy_to, "/home/#{user}/www/rails-guides"
set :deploy_via, :copy


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
