output "ec2-dns" {
    value = aws_instance.nginx-server.public_dns
}