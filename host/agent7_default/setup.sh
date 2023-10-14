#!/bin/bash
echo "alias dd_start='sudo systemctl start datadog-agent'">>~/.bashrc
echo "alias dd_stop='sudo systemctl stop datadog-agent'">>~/.bashrc
echo "alias dd_restart='sudo systemctl start datadog-agent && sudo systemctl stop datadog-agent'">>~/.bashrc
echo "alias dd_status='sudo datadog-agent status'">>~/.bashrc
source ~/.bashrc

