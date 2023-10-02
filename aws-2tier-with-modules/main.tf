module "network_flow" {
  source   = "./modules/network_flow"
  vpc_cidr = "10.0.0.0/16"
}