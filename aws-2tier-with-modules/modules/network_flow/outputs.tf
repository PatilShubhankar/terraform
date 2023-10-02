/*
********************************************
                VPC Outputs
********************************************
*/
output "vpc_id" {
  value = aws_vpc.two_tier_vpc.id
}

output "pub_sub_id" {
  value = aws_subnet.public_subnet.*.id
}



output "priv_sub_id" {
  value = aws_subnet.private_subnet.*.id
}



/*
********************************************
                Gateway Outputs
********************************************
*/

output "two_tier_igw_id" {
  value = aws_internet_gateway.two-tier-igw.id
}

/*
********************************************
               Route Table Outputs
********************************************
*/
output "pub_rt_id" {
  value = aws_route_table.public-route-table.id
}

/*
********************************************
               Security Group Outputs
********************************************
*/

output "alb_sg_id" {
  value = aws_security_group.alb-sg.id
}

output "asg_sg_id" {
  value = aws_security_group.asg-sg.id
}

output "db_sg_id" {
  value = aws_security_group.db-sg.id
}