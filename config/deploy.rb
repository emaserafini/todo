# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'todo'
set :repo_url, 'git@github.com:emaserafini/todo.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, ''

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5



namespace :deploy do
  before :starting, :stop_app do
    on roles(:app) do
      # execute 'docker', 'stop', 'app'
    end
  end
  before :updated, :build_app do
    on roles(:app) do
      within current_path do
        execute :docker, :build, '--rm', '-t', :app, '.'
      end
    end
  end
  after :updated, :migrate do
    on roles(:app) do
      # ci mette qualche secondo a partire
      execute :docker, :run, '-d', '-p 5432:5432', '--name=db postgres'
      sleep 5
      execute :docker, :run, '--link', 'db:db', :app, 'rake db:create db:migrate'
    end
  end
end

after :deploy, :start_app do
  on roles(:app) do
    execute :docker, :run, '-d', '--link', 'db:db', :app, 'rails s'
  end
end

