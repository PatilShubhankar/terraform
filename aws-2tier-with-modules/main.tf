module "network_flow" {
  source   = "./modules/network_flow"
  vpc_cidr = "10.0.0.0/16"
}


module "auto-scaling-group" {
  source         = "./modules/auto-scaling-group"
  lt-instance-sg = module.network_flow.asg_sg_id
  subnet-for-asg = tolist(module.network_flow.pub_sub_id)
}
