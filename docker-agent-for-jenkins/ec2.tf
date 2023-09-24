resource "aws_instance" "web" {

  ami                         = var.ec2-ami-id
  instance_type               = "t3.micro"
  availability_zone           = "eu-north-1a"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true
  user_data                   = <<-EOF
        apt-get update
        apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
        apt-get update
        apt-get install -y docker-ce
        usermod -aG docker ec2-user
        EOF

  tags = {
    Name = "docker-agent-for-jenkins"
  }
}