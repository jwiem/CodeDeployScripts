#!/bin/bash

source /home/ubuntu/.profile
source /home/ubuntu/.bashrc

export NVM_DIR="/home/ubuntu/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# CodeDeploy will error if the project files aren't deleted.
sudo rm -rf /home/ubuntu/Web-Portal/{*,.*}

node_pid=`ps aux | grep "node" | grep -v "grep" | awk -e '{print $2}'`

# Make sure PM2 dies before installing. 
sudo kill $node_pid

# The process by this point should have been killed, but we want to make sure.
running_proccess=`ps aux | grep "node" | grep -v "grep" | wc -l`

if [ ${running_proccess} -ne 0 ]; then
   echo "Was unable to stop node process..."
   exit 1
fi

sudo apt-get update -y
sudo chown -R ubuntu:ubuntu /home/ubuntu/Web-Portal

# Locale settings for python
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# Python
sudo apt-get --quiet install --yes python-pip
python -m pip install awscli --user

# Install Ruby for CodeDeploy-Agent
sudo apt-get install ruby -y

# Get basic details of the running instance
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`"
EC2_ZONE="`wget -q -O - http://169.254.169.254/latest/meta-data/placement/availability-zone`"
EC2_REGION="`echo $EC2_ZONE | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

# Install CodeDeploy Agent
cd ~
wget https://aws-codedeploy-${EC2_REGION}.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Install Node and npm
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
source ~/.profile

# Install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 8.15.0

npm install -g pm2
pm2 update

sudo apt-get install -y git
sudo service nginx start

# Start CodeDeploy Agent
sudo service codedeploy-agent start

exit 0
