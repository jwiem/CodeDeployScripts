#!/bin/bash

source /home/ubuntu/.profile
export NVM_DIR="/home/ubuntu/.nvm" [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
ipaddr=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
listencount=$(netstat -an | grep 1337 | grep LISTEN | wc -l)
if [ "$listencount" -lt 1 ]; then
    exit 1
else
    exit 0
fi
