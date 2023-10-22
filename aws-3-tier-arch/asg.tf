resource "aws_launch_template" "app-tier-launch-template" {
  name_prefix = "app-tier-luanch-template"
  image_id = "ami-0fe8bec493a81c7da"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.app-instances-sg.id  ]
 
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

  vpc_zone_identifier =  aws_subnet.private-subnets.*.id 
  target_group_arns = [ aws_alb_target_group.app-tier-target-group.arn ]
  tag {
    key                 = "Name"
    value               = "ec2-instace"
    propagate_at_launch = true
  }

}