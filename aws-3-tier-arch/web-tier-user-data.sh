#! /bin/bash
cd 

sudo apt update
sudo apt install awscli -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 16
nvm use 16

aws s3 cp s3://aws-3-tier-app-code-bucket/application-code/web-tier/ web-tier --recursive

cd /web-tier
npm install 
npm run build

apt install nginx -y

cd /etc/nginx
aws s3 cp s3://aws-3-tier-app-code-bucket/application-code/nginx.conf .

sed -e "s/\[REPLACE-WITH-INTERNAL-LB-DNS\]/${aws_alb.alb.dns_name}/g" nginx.conf > nginx1.conf
mv nginx1.conf nginx.conf
systemctl restart nginx