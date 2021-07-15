#!/bin/bash

# User-data scripts execute as root, switch to ubuntu user.
sudo apt-get update -y
sudo apt-get install wget

# Locale settings for python
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

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

sudo apt-get install -y build-essential g++

# Install NVM, and NPM as non-root
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
echo 'export NVM_DIR="/home/ubuntu/.nvm"' >> /home/ubuntu/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> /home/ubuntu/.bashrc

cd /home/ubuntu
. /home/ubuntu/.nvm/nvm.sh
. /home/ubuntu/.profile
. /home/ubuntu/.bashrc

# Install NVM, NPM, Node.JS & Grunt
nvm install --lts
nvm ls
npm install -g pm2 yarn node-gyp
pm2 update
apt-get install -y git

sudo service nginx start
sudo service codedeploy-agent start

exit 0

