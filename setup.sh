#!/bin/bash

# Update package lists and install essential packages
sudo apt-get update
sudo apt install curl 

# Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
    source ~/.bashrc  # Adjust this line for your shell (e.g., ~/.zshrc for Zsh)
fi

# Install Node.js LTS using NVM
if ! command -v node &> /dev/null; then
    echo "Installing Node.js LTS..."
    nvm install 18.18.0 
fi

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Install Kubernetes tools (kubectl and kubeadm)
if ! command -v kubectl &> /dev/null; then
    echo "Installing Kubernetes tools..."
    sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl kubeadm
fi

# Install Nginx
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
fi

# Install InfluxDB
if ! dpkg -l | grep -q influxdb; then
    echo "Installing InfluxDB..."
    sudo apt-get install -y influxdb
    sudo systemctl start influxdb
    sudo systemctl enable influxdb
fi

# Install Jenkins
if ! dpkg -l | grep -q jenkins; then
    echo "Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
fi

# Install Grafana
if ! dpkg -l | grep -q grafana; then
    echo "Installing Grafana..."
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
    wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install -y grafana
    sudo systemctl start grafana-server
    sudo systemctl enable grafana-server
fi

echo "Setup complete. You may need to restart your shell to use NVM."
