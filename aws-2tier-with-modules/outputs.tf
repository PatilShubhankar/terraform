output "vpc-id" {
  description = "VPC Id created from module"
  value       = module.network_flow.vpc_id
}

output "aws-vpc-subnet-ids" {
  description = "subnet IDs in VPC"
  value       = module.network_flow.pub_sub_id
}

output "aws-alb-public-dns" {
  value = module.application-load-balancer.alb_dns
}
