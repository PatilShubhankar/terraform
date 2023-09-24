
resource "aws_instance" "web" {
  count = length(var.availability-zone)
  ami                         = var.ec2-ami-id
  instance_type               = "t3.micro"
  availability_zone           = element(var.availability-zone, count.index)
  vpc_security_group_ids      = [aws_security_group.ec2-security-group.id]
  subnet_id                   = element(aws_subnet.private-subnet.*.id, count.index)
  associate_public_ip_address = true
  user_data                   = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        systemctl start httpd
        systemctl enable httpd
        echo "<html><body><h1>10WeeksOfCloudOps</h1></body></html>" > /var/www/html/index.html
        EOF

  tags = {
    Name = "web-${count.index}-instance"
  }
}

