resource "aws_vpc" "nginx-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "nginx-vpc"
  }
}

resource "aws_subnet" "nginx-public-subnet" {
  vpc_id = aws_vpc.nginx-vpc.id

  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-nginx"
  }
}

resource "aws_internet_gateway" "nginx-vpc-igw" {
  vpc_id = aws_vpc.nginx-vpc.id

  tags = {
    Name = "nginx-vpc-igw"
  }
}

resource "aws_route_table" "nginx-rt" {
  vpc_id = aws_vpc.nginx-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx-vpc-igw.id
  }

  tags = {
    Name = "Nginx-rt"
  }
}

resource "aws_route_table_association" "nginx-route-association" {
  subnet_id      = aws_subnet.nginx-public-subnet.id
  route_table_id = aws_route_table.nginx-rt.id
}



resource "aws_security_group" "nginx-sg" {
    name = "nginx-sg"
    description = "Allow traffic on port 22 and port 8080"
    
    vpc_id = aws_vpc.nginx-vpc.id

    ingress {
        description = "Allow for SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Port 8080 used for web servers"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "virtual port that computers use to divert netowrk traffic"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}