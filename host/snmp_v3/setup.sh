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
sudo apt install snmpd snmp libsnmp-dev -y

sudo cp /etc/snmp/snmpd.conf{,.bak}

sudo apt install net-tools -y

sudo systemctl stop snmpd #default_pw: 'vagrant'

sudo cp /usr/bin/net-snmp-create-v3-user ~/

sudo sed -ie '/prefix=/adatarootdir=${prefix}\/share' /usr/bin/net-snmp-create-v3-user

sudo net-snmp-create-v3-user -ro -A datadog2023 -a SHA -X ddsnmp2023 -x AES snmpadmin

#sudo ufw allow from 192.168.99.152 to any port 161 proto udp comment "Allow SNMP Scan from Monitoring Server"
sudo ufw allow from 127.0.0.1 to any port 161 proto udp comment "Allow SNMP Scan from Monitoring Server"


sudo systemctl start snmpd
sudo systemctl enable snmpd

#verification commands:
#netstat -nlpu|grep snmp -v 'will display snmp walk output'
#snmpwalk -v 3 -a SHA -A datadog2023 -x AES -X ddsnmp2023 -l authPriv -u snmpadmin localhost:161
#sudo datadog-agent snmp walk localhost:161 1.3 -v 3 -a SHA -A datadog2023 -x AES -X ddsnmp2023 -l authPriv -u snmpadmin  

#auth-protocol string=SHA
#auth-key string=datadog2023
#priv-proto string=AES
#priv-key string=ddsnmp2023
#security-level string=authPriv
#user: snmpadmin

#passwords: {SHA: "datadog2023"} {AES: "ddsnmp2023"}

sudo cp /home/vagrant/data/conf.yaml /etc/datadog-agent/conf.d/snmp.d/

sudo systemctl restart datadog-agent 
