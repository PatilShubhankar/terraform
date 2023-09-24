
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "aws-docker-agent"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.vpc.id

  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-docker-aws-agent"
  }
}



resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "project-igw2"
  }
}

resource "aws_route_table" "project-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    "Name" = "docker-agent"
  }
}


resource "aws_route_table_association" "project-2-rt-assocaition" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.project-rt.id
}