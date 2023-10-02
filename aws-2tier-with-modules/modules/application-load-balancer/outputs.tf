output "alb_dns" {
  value = aws_lb.public-load-balancer.dns_name
}

output "tg-arn" {
  value = aws_lb_target_group.alb-name.arn
}