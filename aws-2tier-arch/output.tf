
output "alb-dns" {
  value = aws_alb.alb.dns_name
}