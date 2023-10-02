module "network_flow" {
  source   = "./modules/network_flow"
  vpc_cidr = "10.0.0.0/16"
}


module "auto-scaling-group" {
  source         = "./modules/auto-scaling-group"
  lt-instance-sg = module.network_flow.asg_sg_id
  subnet-for-asg = tolist(module.network_flow.priv_sub_id)
  alb_target_arn = module.application-load-balancer.tg-arn
}

module "application-load-balancer" {
  source = "./modules/application-load-balancer"
  alb-sg = module.network_flow.alb_sg_id
  alb-subnets = module.network_flow.pub_sub_id
  tg_port = 80
  tg_protocol = "HTTP"
  vpc_id = module.network_flow.vpc_id
  alb_hc_interval = 60
  alb_hc_path = "/"
  alb_hc_port = 80
  alb_hc_timeout = 45
  alb_hc_protocol = "HTTP"
  #alb_hc_matcher = "200,202"
  alb_listener_port = "80"
  alb_listener_protocol = "HTTP"
}