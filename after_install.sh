#!/bin/bash

# After install stage. 
# This script is setup for a two-stage deployment: staging and production.
source /home/ubuntu/.profile
source /home/ubuntu/.bashrc
export NVM_DIR="/home/ubuntu/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

sudo chown -R ubuntu:ubuntu /home/ubuntu/Web-Portal

if [ "$DEPLOYMENT_GROUP_NAME" == "staging" ]
then
  sudo ln -s /home/ubuntu/path/to/nginx/staging-conf /etc/nginx/sites-enabled/
  sudo ln -s /home/ubuntu/path/to/nginx/staging-conf /etc/nginx/sites-available/
else
  sudo ln -s /home/ubuntu/path/to/nginx/prod-conf /etc/nginx/sites-enabled/
  sudo ln -s /home/ubuntu/path/to/nginx/prod-conf /etc/nginx/sites-available/
fi

cd /home/ubuntu/Web-Portal/
yarn
