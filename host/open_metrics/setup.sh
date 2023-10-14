
#!/bin/bash

# in order to cooperate with the AWS Sandbox environment, let's make sure to
# always rely on the ~/ directory for unix systems
. ~/.sandbox.conf.sh

echo "Provisioning!"

echo "apt-get updating"
apt-get update
echo "install curl if not there..."
apt-get install -y curl


echo "Installing dd-agent from api_key: ${DD_API_KEY}..."

DD_API_KEY=${DD_API_KEY} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"


echo "Adding Agent Configs to dd-agent"
sudo sed -i.bak "s/# hostname: mymachine.mydomain/hostname: $HOSTNAME_BASE.custom_check/g" /etc/dd-agent/datadog.conf
sudo sed -i.bak "s/# tags: mytag, env:prod, role:database/tags: $TAG_DEFAULTS,tester:custom_check/g" /etc/dd-agent/datadog.conf
sudo cp /home/vagrant/data/conf.yaml /etc/datadog-agent/conf.d/openmetrics.d/
sudo rm /etc/dd-agent/datadog.conf.bak
sudo /etc/init.d/datadog-agent stop
sudo /etc/init.d/datadog-agent start

echo "Next Steps"

echo " "
echo "Run command: sudo python3 -m http.server 8080
"
echo "Open new terminal
"
echo "Run command: curl http://127.0.0.1:8080/data/prometheus_exercise.txt
"
#Run command: sudo python3 -m http.server 8080
#Open new terminal
#Run command: curl http://127.0.0.1:8080/data/prometheus_exercise.txt
#https://datadoghq.atlassian.net/wiki/spaces/TS/pages/1653801630/Prometheus+Openmetrics+Hands-on+Troubleshooting+Prometheus+Payloads