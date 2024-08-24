#!/bin/bash

# Function to stop a process by its name or port
stop_process() {
  local NAME=$1
  local PID_COMMAND=$2
  local PID=$($PID_COMMAND)
  
  if [ -n "$PID" ]; then
    kill -9 $PID
    echo "Stopped $NAME process."
  else
    echo "No $NAME process running."
  fi
}

# Stop Rails server running on port 3000
PORT=3000
stop_process "Rails server on port $PORT" "lsof -i tcp:$PORT -t"

# Stop any running Sidekiq processes
stop_process "Sidekiq" "pgrep -f sidekiq"

# Stop any running Vite processes
stop_process "Vite" "pgrep -f vite"

echo "All specified processes have been checked and stopped if running."
