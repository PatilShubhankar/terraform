resource "aws_launch_template" "app-tier-launch-template" {
  name_prefix            = "app-tier-luanch-template"
  image_id               = "ami-0fe8bec493a81c7da"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.app-instances-sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 8
      delete_on_termination = true
      volume_type           = "gp2"
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app-ec2-instances"
    }
  }
  user_data = filebase64("app-tier-user-data.sh")
  iam_instance_profile {
    name = aws_iam_instance_profile.instance-profile-for-ec2.name
  }
}

resource "aws_autoscaling_group" "my-asg" {
  name = "my-asg"
  launch_template {
    id      = aws_launch_template.app-tier-launch-template.id
    version = "$Latest"
  }
  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  vpc_zone_identifier = aws_subnet.private-subnets.*.id
  target_group_arns   = [aws_alb_target_group.app-tier-target-group.arn]
  tag {
    key                 = "Name"
    value               = "ec2-instace-app-tier"
    propagate_at_launch = true
  }

}



resource "aws_launch_template" "web-tier-launch-template" {
  name_prefix            = "web-tier-luanch-template"
  image_id               = "ami-0fe8bec493a81c7da"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.public-elb-sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 8
      delete_on_termination = true
      volume_type           = "gp2"
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-ec2-instances"
    }
  }
  user_data = <<EOF
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
  iam_instance_profile {
    name = aws_iam_instance_profile.instance-profile-for-ec2.name
  }
}



resource "aws_autoscaling_group" "web-tier-asg" {
  name = "web-tier-asg"
  launch_template {
    id      = aws_launch_template.web-tier-launch-template.id
    version = "$Latest"
  }
  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  vpc_zone_identifier = aws_subnet.private-subnets.*.id
  
  tag {
    key                 = "Name"
    value               = "ec2-instace-web-tier"
    propagate_at_launch = true
  }
}