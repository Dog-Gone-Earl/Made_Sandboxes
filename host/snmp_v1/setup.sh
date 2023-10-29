#!/bin/bash

. ~/.sandbox.conf.sh

echo "Provisioning!"
echo ""

echo "apt-get updating"
sudo apt-get update -y
sudo apt-get upgrade -y
echo "install curl if not there..."
sudo apt-get install -y curl

echo "Installing dd-agent from api_key: ${DD_API_KEY}..."
DD_API_KEY=${DD_API_KEY} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
sudo apt-get install snmpd -y ; sudo apt install snmp -y

sudo cp -r /etc/datadog-agent/conf.d/snmp.d/conf.yaml.example /etc/datadog-agent/conf.d/snmp.d/conf.yaml
sudo sed '73i rocommunity public' /etc/snmp/snmpd.conf
sudo sed -i "s/agentaddress  127.0.0.1,[::1]/agentAddress udp:161,udp6:[::1]:161/1" /etc/snmp/snmpd.conf
sudo sed -i "s/    # ip_address: <IP_ADDRESS>/    ip_address: localhost/1" /etc/datadog-agent/conf.d/snmp.d/conf.yaml
sudo sed -i "s/    # community_string: <COMMUNITY_STRING>/    community_string: public/1" /etc/datadog-agent/conf.d/snmp.d/conf.yaml
sudo sed -i "s/    # tags:/    tags:/1" /etc/datadog-agent/conf.d/snmp.d/conf.yaml
sudo sed -i "s/    #   - <KEY_1>:<VALUE_1>/      - location:colorado/1" /etc/datadog-agent/conf.d/snmp.d/conf.yaml
sudo service snmpd restart
sudo systemctl restart datadog-agent



#Run agent/snmpwalk
#snmpwalk -v 1 -c public -ObentU localhost:161 1.3
#sudo datadog-agent snmp walk localhost:161 1.3 -C public