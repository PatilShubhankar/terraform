output "vpc-id" {
  description = "VPC Id created from module"
  value = module.network_flow.vpc_id
}