#!/bin/bash

source /home/ubuntu/.profile
source /home/ubuntu/.bashrc
export NVM_DIR="/home/ubuntu/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Ensure frontend has write access.
# For whatever reason, Grunt never does a good job of cleaning up after itself in the .tmp directory.
cd /home/ubuntu/Web-Portal
sudo chown -R 1000 /home/ubuntu/Web-Portal/.tmp
sudo chown -R 1000 assets/
if [ "$DEPLOYMENT_GROUP_NAME" == "staging" ]
then
  yarn && pm2 start app.config.js
else
  yarn start-prod
fi
