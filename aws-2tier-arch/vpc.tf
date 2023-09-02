
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.subnet-counts)
  availability_zone       = element(var.availability-zone, count.index)
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${element(var.availability-zone, count.index)}"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.subnet-counts)
  availability_zone = element(var.availability-zone, count.index)
  cidr_block        = "10.0.${count.index + 2}.0/24"

  tags = {
    Name = "private-subnet-${element(var.availability-zone, count.index)}"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "public route-table"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  count          = length(var.subnet-counts)
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.public-route-table.id
}

