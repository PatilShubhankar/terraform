/*resource "aws_instance" "aws-web-tier-test-instance" {
  ami                         = "ami-0fe8bec493a81c7da"
  instance_type               = "t3.micro"
  availability_zone           = "eu-north-1a"
  vpc_security_group_ids      = [aws_security_group.public-elb-sg.id]
  subnet_id                   = aws_subnet.public-subnets[0].id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.instance-profile-for-ec2.id
  user_data_replace_on_change = true
  
  user_data = <<-EOF
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
  EOF
  tags = {
    Name = "web-test-instance"
  }

}

*/