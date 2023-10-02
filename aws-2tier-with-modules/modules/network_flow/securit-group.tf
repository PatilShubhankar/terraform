#Create security group for ALB
resource "aws_security_group" "alb-sg" {
  name        = var.alb-sg-name
  description = "Allow HTTP traffic"

  vpc_id     = aws_vpc.two_tier_vpc.id
  depends_on = [aws_vpc.two_tier_vpc]

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb-sg-name
  }
}

#Cretae Security group for Auto scaling group 
resource "aws_security_group" "asg-sg" {
  name   = var.asg-sg-name
  vpc_id = aws_vpc.two_tier_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create security group for DB
resource "aws_security_group" "db-sg" {
  name   = var.db-sg-name
  vpc_id = aws_vpc.two_tier_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.asg-sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.asg-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}