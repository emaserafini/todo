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

  after :set_current_revision, :build_images do
    on roles(:app) do
      unless test("docker ps -f status=running | grep ' db '")
        if test("docker ps -a | grep ' db '")
          execute :docker, :start, 'db'
        else
          execute :docker, :run, '-d', '-p 5432:5432', '--name=db postgres'
        end
      end
      unless test("docker ps -f status=running | grep ' redis '")
        if test("docker ps -a | grep ' redis '")
          execute :docker, :start, 'redis'
        else
          execute :docker, :run, '-d --name=redis redis'
        end
      end
      within release_path do
        execute :docker, :build, '--rm', '-t', :app, '.'
      end
    end
  end

  before :starting, :stop_app do
    on roles(:app) do
      if test("docker ps -f status=running | grep ' app '")
        execute :docker, :stop, 'app'
      end
      if test("docker ps -a | grep ' app '")
        execute :docker, :rm, 'app'
      end
    end
  end
  # before :updated, :build_app do
  #   on roles(:app) do
  #     within current_path do
  #       execute :docker, :build, '--rm', '-t', :app, '.'
  #     end
  #   end
  # end
  after :updated, :migrate do
    on roles(:app) do
      execute :docker, :run, '--rm --link db:db app rake db:create db:migrate'
    end
  end
end

after :deploy, :start_app do
  on roles(:app) do
    execute :docker, :run, '-d --link db:db -p 80:3000 --name=app app rails s -b 0.0.0.0'
  end
end

