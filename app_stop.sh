#!/bin/bash

source /home/ubuntu/.profile
export NVM_DIR="/home/ubuntu/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
cd /home/ubuntu/Web-Portal
pm2 stop webportal
