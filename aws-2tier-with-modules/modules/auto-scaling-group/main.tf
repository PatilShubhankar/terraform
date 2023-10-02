#Create an autoscaling group 
resource "aws_autoscaling_group" "trf-module-asg" {
  name                = var.asg_name
  min_size            = var.min-capacity
  max_size            = var.max-capacity
  desired_capacity    = var.desired-capacity
  vpc_zone_identifier = var.subnet-for-asg
  launch_template {
    id = aws_launch_template.lt-asg.id
  }

  tag {
    key                 = "Name"
    value               = var.asg_tag_name
    propagate_at_launch = true
  }
}

#Create launch template 
resource "aws_launch_template" "lt-asg" {
  name                   = var.lt-asg-name
  image_id               = var.lt-asg-ami
  instance_type          = var.lt-asg-intance-type
  vpc_security_group_ids = [var.lt-instance-sg]
  user_data              = filebase64("${path.root}/install-apche.sh")
}