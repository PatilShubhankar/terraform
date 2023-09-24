resource "aws_lb" "project_alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public-subnet.*.id]
}

#Create the ALB target group
resource "aws_lb_target_group" "project_tg" {
  name     = "project-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  depends_on = [aws_vpc.vpc]
}

#Create the target attachments
resource "aws_lb_target_group_attachment" "tg_attach1" {
  target_group_arn = aws_lb_target_group.project_tg.arn
  target_id        = aws_instance.web[0].id
  port             = 80

  depends_on = [aws_instance.web[0]]
}

resource "aws_lb_target_group_attachment" "tg_attach2" {
  target_group_arn = aws_lb_target_group.project_tg.arn
  target_id        = aws_instance.web[1].id
  port             = 80

  depends_on = [aws_instance.web[1]]
}

#Create the listener
resource "aws_lb_listener" "listener_lb" {
  load_balancer_arn = aws_lb.project_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project_tg.arn
  }
}