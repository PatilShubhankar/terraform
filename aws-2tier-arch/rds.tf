
resource "aws_security_group" "db-security-group" {
  name        = "db-security-group"
  description = "Allow inboud traffic from EC2 instance"

  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-sunet-group"
  subnet_ids = aws_subnet.private-subnet.*.id
}

resource "aws_db_instance" "mysql-db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  identifier             = "test"
  username               = "admin"
  password               = "12345678"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.db-security-group.id] # Attach the RDS security group

  tags = {
    Name = "MySQl DB"
  }
}