#!/bin/bash

. ~/.sandbox.conf.sh

echo "Provisioning!"

echo "apt-get updating"
sudo apt-get update -y
sudo apt-get upgrade -y

echo "install curl if not there..."
apt-get install -y curl

sudo apt install python3-pip -y

pip install datadog-api-client

echo "Installing dd-agent from api_key: ${DD_API_KEY}..."
DD_API_KEY=${DD_API_KEY} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"


echo "alias dd_start='sudo systemctl start datadog-agent'">>~/.bashrc
echo "alias dd_stop='sudo systemctl stop datadog-agent'">>~/.bashrc
echo "alias dd_restart='sudo systemctl start datadog-agent && sudo systemctl stop datadog-agent'">>~/.bashrc
echo "alias dd_status='sudo datadog-agent status'">>~/.bashrc
#Set datadog.yaml information
sudo sed -i.yaml "s/# hostname: <HOSTNAME_NAME>/hostname: ubuntu_jammy/1" /etc/datadog-agent/datadog.yaml
sudo sed -i.yaml "s/# env: <environment name>/env: lighthouse_sandbox/1" /etc/datadog-agent/datadog.yaml

source ~/.bashrc


sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
sudo echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y

#sudo apt-get install -y nodejs
sudo apt-get install npm -y
sudo npm install -g npm@10.2.1
sudo apt-get install chromium-browser -y
sudo datadog-agent integration install -tr datadog-lighthouse==2.2.0

