
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
  vpc_id                  = aws_vpc.two_tier_vpc.id
  cidr_block              = var.pub_subnet_cidr
  availability_zone       = var.subnet_az
  map_public_ip_on_launch = var.map_public_ip

  tags = {
    Name = var.subent_name
  }
}

#Private subnet in VPC
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.two_tier_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.subnet_az

  tags = {
    Name = var.subent_name
  }
}
