
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "project2-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.vpc.id

  count                   = length(var.availability-zone)
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = element(var.availability-zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-project-2-${element(var.availability-zone, count.index)}"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.vpc.id

  count                   = length(var.availability-zone)
  cidr_block              = "10.0.${count.index + 2}.0/24"
  availability_zone       = element(var.availability-zone, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-project-2-${element(var.availability-zone, count.index)}"
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
    "Name" = "project2-route-table"
  }
}


resource "aws_route_table_association" "project-2-rt-assocaition" {
  count          = length(var.availability-zone)
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.project-rt.id
}