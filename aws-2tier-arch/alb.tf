resource "aws_security_group" "alb-sg" {
  name        = "alb-security-group"
  description = "Security group of alb"

  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_alb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = aws_subnet.public-subnet.*.id
}

resource "aws_alb_target_group" "my-target-group-https" {
  name     = "my-target-group-https"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
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
    target_group_arn = aws_alb_target_group.my-target-group-https.arn
  }

  condition {
    path_pattern {
      values = ["/signup"]
    }
  }

  priority = 1
}

resource "aws_alb_listener_rule" "alb_listener_rule_signin" {
  listener_arn = aws_alb_listener.alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.my-target-group-https.arn
  }

  condition {
    path_pattern {
      values = ["/signin"]
    }
  }

  priority = 2
}

resource "aws_alb_listener_rule" "alb_listener_rule_dashboard" {
  listener_arn = aws_alb_listener.alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.my-target-group-https.arn
  }

  condition {
    path_pattern {
      values = ["/dashboard"]
    }
  }

  priority = 3
}

