#!/bin/bash


git clone https://github.com/kevin-samson/azure-cloud

cd azure-cloud

# Define folder paths
FRONTEND_DIR="/home/azureuser/azure-cloud/website/frontend"
BACKEND_DIR="/home/azureuser/azure-cloud/website/backend"

# Define log files
FRONTEND_LOG="frontend.log"
BACKEND_LOG="backend.log"

# Function to install NVM and Node.js
install_nvm_and_node() {
  echo "Installing NVM (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

  # Load NVM into the current shell session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

  echo "Installing the latest stable version of Node.js..."
  nvm install --lts
}

# Ensure NVM is installed
if ! command -v nvm &> /dev/null; then
  echo "NVM is not installed."
  install_nvm_and_node
else
  echo "NVM is already installed."
  # Load NVM into the current shell session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Ensure Node.js and npm are available
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
  echo "Node.js or npm is not installed. Installing..."
  nvm install --lts
else
  echo "Node.js and npm are already installed."
fi


# Ensure 'serve' is installed
echo "Checking if 'serve' is installed..."
if ! command -v serve &> /dev/null; then
  echo "'serve' not found. Installing..."
  npm install -g serve || { echo "Failed to install 'serve'. Exiting."; exit 1; }
else
  echo "'serve' is already installed."
fi

# Launch frontend
echo "Building and serving frontend..."
cd $FRONTEND_DIR

if [ -d "build" ]; then
  echo "Build folder already exists. Skipping build step."
else
  npm install && npm run build || { echo "Frontend build failed! Exiting."; exit 1; }
fi

# Serve frontend in the background
serve -s build -l 3001 > "../$FRONTEND_LOG" 2>&1 &
FRONTEND_PID=$!
echo "Frontend is running in the background. PID: $FRONTEND_PID"

sed -i 's/mongodb:\/\/10.0.1.4/mongodb:\/\/10.0.0.4/g' /home/azureuser/azure-cloud/website/backend/DB/Database.js
# Launch backend
echo "Starting backend server..."
cd $BACKEND_DIR
npm install # Ensure dependencies are installed
nohup node app.js > "../$BACKEND_LOG" 2>&1 &
BACKEND_PID=$!
echo "Backend is running in the background. PID: $BACKEND_PID"

# Print summary
echo "---------------------------------------"
echo "Frontend log: $FRONTEND_LOG"
echo "Backend log: $BACKEND_LOG"
echo "Frontend PID: $FRONTEND_PID"
echo "Backend PID: $BACKEND_PID"
echo "---------------------------------------"
echo "MERN app launched successfully!"

