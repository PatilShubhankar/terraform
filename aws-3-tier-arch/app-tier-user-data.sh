#! /bin/bash
cd 
sudo apt update -y
sudo apt install mysql-server -y
sudo systemctl start mysql.service
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 16
nvm use 16
npm install -g pm2 
sudo apt update
sudo apt install awscli -y
aws s3 cp s3://aws-3-tier-app-code-bucket/app-code/ app-tier --recursive
cd app-tier
npm install
pm2 start index.js