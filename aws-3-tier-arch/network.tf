
#Create VPC for 3 Tier project 
resource "aws_vpc" "three-tier-project-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "three-tier-project-vpc"
  }
}

resource "aws_subnet" "public-subnets" {
  vpc_id = aws_vpc.three-tier-project-vpc.id

  count = length(var.aws-availability-zone)

  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = element(var.aws-availability-zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-|||-${count.index}"
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id = aws_vpc.three-tier-project-vpc.id

  count = length(var.aws-availability-zone)

  cidr_block = "10.0.${count.index + 2}.0/24"
  availability_zone = element(var.aws-availability-zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "private-subnet-|||-${count.index}"
  }
}

resource "aws_subnet" "private-db-subnets" {
  vpc_id = aws_vpc.three-tier-project-vpc.id
  count = length(var.aws-availability-zone)
  cidr_block = "10.0.${count.index + 4}.0/24"
  availability_zone = element(var.aws-availability-zone, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private-db-subnet-|||-${count.index}"
  }
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-sunet-group"
  subnet_ids = aws_subnet.private-db-subnets.*.id
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.three-tier-project-vpc.id

  tags = {
    Name = "three-tier-igw2"
  }
}

resource "aws_route_table" "project-rt" {
  vpc_id = aws_vpc.three-tier-project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    "Name" = "three-tier-route-table"
  }
}

resource "aws_route_table_association" "three-tier-route-table-assocaition" {
  count          = length(var.aws-availability-zone)
  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.project-rt.id
}

resource "aws_route_table_association" "three-tier-route-table-assocaition-test" {
  count          = length(var.aws-availability-zone)
  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = aws_route_table.project-rt.id
}
