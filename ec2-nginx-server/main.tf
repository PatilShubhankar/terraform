
resource "aws_instance" "nginx-server" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.nginx-sg.id ]
  subnet_id = aws_subnet.nginx-public-subnet.id
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install nginx -y
  EOF

  user_data_replace_on_change = true

  tags = {
    Name = "nginx-server"
  }
}