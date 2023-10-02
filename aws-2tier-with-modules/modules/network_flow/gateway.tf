#Crearte an internet gateway and associate it with VPC
resource "aws_internet_gateway" "two-tier-igw" {
  vpc_id = aws_vpc.two_tier_vpc.id

  tags = {
    Name = var.igw-name
  }
}