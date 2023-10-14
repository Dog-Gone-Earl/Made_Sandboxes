Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "hajowieland/ubuntu-jammy-arm"
  config.vm.hostname = "td.dev.box"
  config.vm.provider "vmware_desktop" do |v|
    v.ssh_info_public = true
    v.gui = true
    v.linked_clone = false
    v.vmx["ethernet0.virtualdev"] = "vmxnet3"
    end 
  config.vm.synced_folder "./shared", "/home/vagrant/shared", create: true
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
  sudo apt-get update
  yes y | sudo apt-get upgrade

  sudo apt  install docker.io -y
  git clone https://github.com/DataDog/datadog-agent.git
  cd datadog-agent/Dockerfiles/agent/
  mkdir arm64 && cd arm64 && touch Dockerfile && echo "FROM datadog/agent:7.43.0" >Dockerfile && cd ..
  git branch 7.43.0-1 && git checkout 7.43.0-1
  curl https://s3.amazonaws.com/apt.datadoghq.com/pool/d/da/datadog-agent_7.43.0-1_arm64.deb -o datadog-agent_7.43.0-1_arm64.deb

  sudo docker build --build-arg DD_AGENT_ARTIFACT=./datadog-agent_7.43.0-1_arm64.deb --file arm64/Dockerfile --pull --tag datadog:7.43.0 /home/vagrant
  SHELL
end