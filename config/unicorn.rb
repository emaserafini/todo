# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/app"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/app/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/app/log/unicorn.log"
stdout_path "/app/log/unicorn.log"

# Unicorn socket
listen "/socks/unicorn.todo.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
