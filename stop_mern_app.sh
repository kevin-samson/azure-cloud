#!/bin/bash

# Read stored PIDs (if saved in the previous script)
FRONTEND_PID=$(ps aux | grep "serve -s build" | grep -v grep | awk '{print $2}')
BACKEND_PID=$(ps aux | grep "node server.js" | grep -v grep | awk '{print $2}')

# Stop frontend
if [ -n "$FRONTEND_PID" ]; then
  echo "Stopping frontend (PID: $FRONTEND_PID)..."
  kill "$FRONTEND_PID" && echo "Frontend stopped successfully."
else
  echo "Frontend is not running."
fi

# Stop backend
if [ -n "$BACKEND_PID" ]; then
  echo "Stopping backend (PID: $BACKEND_PID)..."
  kill "$BACKEND_PID" && echo "Backend stopped successfully."
else
  echo "Backend is not running."
fi
