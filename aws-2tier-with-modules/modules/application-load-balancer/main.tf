
#Create application load balancer
resource "aws_lb" "public-load-balancer" {
  name = var.alb-name
  internal = var.disable-interanle-alb
  load_balancer_type = "application"
  security_groups = [var.alb-sg]
  subnets = var.alb-subnets

  enable_deletion_protection = false

  tags = {
    Name = var.pub_sub_alb_tag
  }
}


resource "aws_lb_target_group" "alb-name" {
  name = var.alb-taget-name
  port = var.tg_port
  protocol = var.tg_protocol
  vpc_id = var.vpc_id

  health_check {
    interval = var.alb_hc_interval
    path = var.alb_hc_path
    port = var.alb_hc_port
    timeout = var.alb_hc_timeout
    protocol = var.alb_hc_protocol
    #matcher = var.alb_hc_matcher
  }
}


resource "aws_lb_listener" "alb-listner" {
  load_balancer_arn = aws_lb.public-load-balancer.arn
  port = var.alb_listener_port
  protocol =  var.alb_listener_protocol

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-name.arn
  }
}

