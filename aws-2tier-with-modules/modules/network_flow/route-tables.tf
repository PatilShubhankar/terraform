
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.two_tier_vpc.id
  route {
    cidr_block = var.public-rt-cidr
    gateway_id = aws_internet_gateway.two-tier-igw.id
  }
  tags = {
    Name = var.public-route-table-name
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public-route-table.id
}