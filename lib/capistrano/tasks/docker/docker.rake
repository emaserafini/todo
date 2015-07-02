namespace :docker do

  task :kill_app do
    on roles :app do
      if test("docker ps -f status=running | grep ' app '")
        info "Killing app"
        execute :docker, :kill, 'app'
      end
    end
  end

  task :build_app do
    on roles :app do
      within release_path do
        execute :docker, :build, '--rm -t app .'
      end
    end
  end

  task :start_db do
    on roles :app do
      if test("docker ps -f status=running | grep ' db '")
        info 'DB is already running'
      elsif test("docker ps -a | grep ' db '")
        info 'Starting DB'
        execute :docker, :start, :db
      else
        info 'Running DB'
        execute :docker, :run, '-d -p 5432:5432 --name=db postgres'
      end
    end
  end

  task :start_redis do
    on roles :app do
      if test("docker ps -f status=running | grep ' redis '")
        info 'redis is already running'
      elsif test("docker ps -a | grep ' redis '")
        info 'Starting redis'
        execute :docker, :start, :redis
      else
        info 'Running redis'
        execute :docker, :run, '-d --name=redis redis'
      end
    end
  end

  task :run_app do
    on roles :app do
      execute :docker, :run, '--rm -t app .'
    end
  end

  task :show_all do
    on roles :app do
      info execute(:docker, :ps, '-a')
    end
  end
end