#!/bin/bash

sudo apt-get install nodejs npm chromium-browser -y
sudo npm install -g lighthouse
DD_API_KEY=${DD_API_KEY} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
datadog-agent integration install -tr datadog-lighthouse==2.2.0

