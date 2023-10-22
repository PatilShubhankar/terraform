
/*resource "aws_instance" "aws-app-tier-test-instance" {
  ami                         = "ami-0fe8bec493a81c7da"
  instance_type               = "t3.micro"
  availability_zone           = "eu-north-1a"
  vpc_security_group_ids      = [aws_security_group.app-instances-sg.id]
  subnet_id                   = aws_subnet.private-subnets[0].id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.instance-profile-for-ec2.id
  user_data_replace_on_change = true
  tags = {
    Name = "app-test-instance"
  }
  user_data = <<-EOF
    #! /bin/bash
    cd 
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
  EOF
}


*/