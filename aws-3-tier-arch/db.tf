#data base tier
resource "aws_db_instance" "mysql-db" {
  allocated_storage      = 10
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
  vpc_security_group_ids = [aws_security_group.db-sg.id] # Attach the RDS security group
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  tags = {
    Name = "MySQl DB"
  }
}