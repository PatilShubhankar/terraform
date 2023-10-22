
resource "aws_security_group" "public-elb-sg" {
  name        = "public-elb-sg"
  description = "Allow web and ssh traffic"
  vpc_id      = aws_vpc.three-tier-project-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-tier-instacnes-sg" {
  name = "web-tier-instacnes-sg"
  vpc_id = aws_vpc.three-tier-project-vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.public-elb-sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal-elb-sg" {
  name = "internal-elb-sg"
  vpc_id = aws_vpc.three-tier-project-vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.web-tier-instacnes-sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "app-instances-sg" {
  name = "app-instances-sg"
  vpc_id = aws_vpc.three-tier-project-vpc.id
/*
  ingress {
    from_port = 4000
    to_port = 4000
    protocol = "tcp"
    security_groups = [ aws_security_group.internal-elb-sg.id ]
  } */
/*
  ingress {
    from_port = 4000
    to_port = 4000
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
*/
  ingress {
    from_port = 4000
    to_port = 4000
    protocol = "tcp"
    security_groups = [ aws_security_group.public-elb-sg.id ]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db-sg" {
  name = "db-sg"
  vpc_id = aws_vpc.three-tier-project-vpc.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [ aws_security_group.app-instances-sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}