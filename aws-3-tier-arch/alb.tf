resource "aws_alb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-elb-sg.id]
  subnets            = aws_subnet.public-subnets.*.id
}


resource "aws_alb_target_group" "app-tier-target-group" {
  name        = "app-tier-target-group"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.three-tier-project-vpc.id
  target_type = "instance"

  health_check {
    interval = 30
    path     = "/health"
    port     = 4000
    timeout  = 10
    protocol = "HTTP"
    matcher  = "200"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default response from ALB"
      status_code  = "200"
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_alb_listener.alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app-tier-target-group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  priority = 1
}


resource "aws_autoscaling_attachment" "atch-asg-alb" {
  autoscaling_group_name = aws_autoscaling_group.my-asg.name
  lb_target_group_arn    = aws_alb_target_group.app-tier-target-group.arn
}



#########################
#Web tier public ALB
#########################
resource "aws_alb" "web-alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-elb-sg.id]
  subnets            = aws_subnet.public-subnets.*.id
}


resource "aws_alb_target_group" "web-tier-target-group" {
  name        = "web-tier-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.three-tier-project-vpc.id
  target_type = "instance"

  health_check {
    interval = 30
    path     = "/health"
    port     = 80
    timeout  = 10
    protocol = "HTTP"
    matcher  = "200"
  }
}

resource "aws_alb_listener" "web-alb_listener" {
  load_balancer_arn = aws_alb.web-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default response from ALB"
      status_code  = "200"
    }
  }
}

resource "aws_alb_listener_rule" "web-alb_listener_rule" {
  listener_arn = aws_alb_listener.web-alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web-tier-target-group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  priority = 1
}


resource "aws_autoscaling_attachment" "atch-web-asg-alb" {
  autoscaling_group_name = aws_autoscaling_group.web-tier-asg.name
  lb_target_group_arn    = aws_alb_target_group.web-tier-target-group.arn
}
