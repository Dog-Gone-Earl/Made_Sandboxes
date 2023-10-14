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

sudo net-snmp-create-v3-user -ro -A STrP@SSWRD -a SHA -X STr0ngP@SSWRD -x AES snmpadmin

sudo systemctl start snmpd
sudo systemctl enable snmpd

#run commands:
#netstat -nlpu|grep snmp -v 'will display snmp walk output'
# snmpwalk -v3 -a SHA -A STrP@SSWRD -x AES -X STr0ngP@SSWRD -l authPriv -u snmpadmin <127.ip_address>

#username: snmpadmin
#password: {SHA: "STrP@SSWRD"} {AES: "STr0ngP@SSWRD"}


sudo cp /home/vagrant/data/conf.yaml /etc/datadog-agent/conf.d/snmp.d/

"""
init_config:
    loader: core
    use_device_id_as_hostname: true
instances:
  -
    ip_address: localhost
    snmp_version: 3
    loader: core
    use_device_id_as_hostname: true
    user: snmpadmin
    authProtocol: 'SHA256'
    authKey: 'STrP@SSWRD'
    privProtocol: 'AES256'
    privKey: 'STr0ngP@SSWRD'
    tags:
      - env:sandbox 
"""
sudo systemctl restart datadog-agent 
#ufw allow from 192.168.99.152 to any port 161 proto udp comment "Allow SNMP Scan from Monitoring Server"