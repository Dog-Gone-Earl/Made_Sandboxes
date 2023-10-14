#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install python -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker

sudo curl -Ls "https://sbom.k8s.io/$(curl -Ls https://dl.k8s.io/release/stable.txt)/release" | grep "SPDXID: SPDXRef-Package-registry.k8s.io" |  grep -v sha256 | cut -d- -f3- | sed 's/-/\//' | sed 's/-v1/:v1/'
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube

#Helm Install
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update

#Agent helm repo install
sudo apt-get install helm
helm repo add datadog https://helm.datadoghq.com && helm repo update

#install Flux CLI
curl -s https://fluxcd.io/install.sh | sudo bash

echo "
Completed!"
