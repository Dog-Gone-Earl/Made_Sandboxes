#!/bin/bash

user=root
database=widget_database
table=parts_table 


# in order to cooperate with the AWS Sandbox environment, let's make sure to
# always rely on the ~/ directory for unix systems
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


echo "Adding Agent Configs to dd-agent"
echo ""

sudo sed -i.yaml "s/# hostname: <HOSTNAME_NAME>/hostname: mysql_sandbox/1" /etc/datadog-agent/datadog.yaml
sudo sed -i.yaml "s/# env: <environment name>/env: db_prod/1" /etc/datadog-agent/datadog.yaml
sudo cp "/etc/datadog-agent/conf.d/mysql.d/conf.yaml.example" "/etc/datadog-agent/conf.d/mysql.d/conf.yaml"
sudo sed -i.yaml "s/  - host: localhost/  - host: 127.0.0.1/1" /etc/datadog-agent/conf.d/mysql.d/conf.yaml
sudo sed -i.yaml "s/    password: <PASSWORD>/    password: Datadog2023/1" /etc/datadog-agent/conf.d/mysql.d/conf.yaml

sudo /etc/init.d/datadog-agent stop

echo "Installing pip and Python datadog module"
echo ""

sleep 3
sudo apt-get install python3.7 -y
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2
sudo -H apt-get install python3-pip -y
sudo -h $HOSTNAME pip3 install datadog
python3 -m pip install --upgrade pip

  
echo "Mysql install"
echo ""

sleep 3
sudo apt-get install mysql-server -y
sudo pip3 install mysql-connector-python
sudo mysql --user=$user --execute="CREATE DATABASE $database; USE $database; CREATE TABLE $table (quan INT(1), parts VARCHAR(5), price INT(4)); "
sudo mysql --user=$user --execute="CREATE USER 'parts_buyer'@'localhost' IDENTIFIED BY 'TD2023'; GRANT ALL ON *.* TO 'parts_buyer'@'localhost'; FLUSH PRIVILEGES;"
sudo mysql --user=$user --execute="CREATE USER 'datadog'@'%' IDENTIFIED BY 'Datadog2023'; GRANT REPLICATION CLIENT ON *.* TO 'datadog'@'%';" 
sudo mysql --user=$user --execute="ALTER USER 'datadog'@'%' WITH MAX_USER_CONNECTIONS 5;GRANT PROCESS ON *.* TO 'datadog'@'%';"
sudo mysql --user=$user --execute="GRANT SELECT ON performance_schema.* TO 'datadog'@'%';"

echo "Retrieving Python file"
echo ""

sleep 3
sudo cp -r "/home/vagrant/data/widget.py" "/home/vagrant"
sudo systemctl stop datadog-agent && sudo systemctl start datadog-agent

echo "Mysql Sandbox Deployed!"