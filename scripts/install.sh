#!/usr/bin/env bash
set -euo pipefail

sudo apt update && sudo apt -y upgrade
sudo apt -y install openjdk-11-jdk tomcat9 tomcat9-admin apache2 mysql-client unzip
sudo systemctl enable --now tomcat9 apache2
echo "Base stack installed."
