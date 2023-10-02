
# Creaate an AWS VPC
resource "aws_vpc" "two_tier_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.vpc_instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostname

  tags = {
    Name = var.vpc_name
  }
}


#Public subnet in VPC
resource "aws_subnet" "public_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.two_tier_vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = var.map_public_ip
  tags = {
    Name = "trf-module-public-subnet-${count.index}"
  }
}

#Private subnet in VPC
resource "aws_subnet" "private_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.two_tier_vpc.id
  cidr_block        = "10.0.${length(var.availability_zones) + count.index}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "trf-module-private-subnet-${count.index}"
  }
}
