
resource "aws_launch_template" "ec2-launch-template" {
  name_prefix   = "ec2-launch-template"
  image_id      = var.ec2-ami-id
  instance_type = "t3.micro"

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
      Name = "ec2-instances"
    }
  }
  user_data = filebase64("user-data.sh")
  iam_instance_profile {
    name = aws_iam_instance_profile.instance-profile.name
  }
}


resource "aws_autoscaling_group" "my-asg" {
  name = "my-asg"
  launch_template {
    id      = aws_launch_template.ec2-launch-template.id
    version = "$Latest"
  }
  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  vpc_zone_identifier = aws_subnet.public-subnet.*.id

  target_group_arns = [ aws_alb_target_group.my-target-group-https.arn ]

  tag {
    key                 = "Name"
    value               = "ec2-instace"
    propagate_at_launch = true
  }

}

resource "aws_security_group" "ec2-sg" {
  name   = "ec2-security-group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}