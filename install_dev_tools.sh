#!/bin/bash
# Ubuntu
set -e

sudo apt update
sudo apt upgrade -y

# Installing Docker
if command -v docker &> /dev/null; then
  echo "Docker already installed"
else
  echo "Installing Docker..."
  sudo apt install -y ca-certificates curl gnupg lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# Installing Python
if python3 -c "import sys; exit(not (sys.version_info >= (3, 9)))"; then
  echo "Python version >= 3.9 already installed"
else
  echo "Installing Python 3..."
  sudo apt install -y python3
fi

# Installing pip
if command -v pip3 &> /dev/null; then
  echo "pip already installed"
else 
  echo "Installing pip..."
  sudo apt install -y python3-pip
fi

# Setting up virtual environment
if python3 -m venv --help > /dev/null 2>&1; then
  echo "venv module is available"
else 
  echo "Installing python3-venv..."
  sudo apt install -y python3-venv
fi

if [ -d "venv" ]; then
  echo "Removing old virtual environment"
  rm -rf venv
fi

echo "Creating and activating new virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Installing Django in venv
if python -m django --version > /dev/null 2>&1; then
  echo "Django already installed in virtual environment"
else 
  echo "Installing Django..."
  pip install --upgrade pip
  pip install django
fi

echo "Installation completed successfully"
