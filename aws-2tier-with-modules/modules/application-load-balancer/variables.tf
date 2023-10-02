/*
*****************************************************
                ALB VARIABLES
*****************************************************
*/

variable "alb-name" {
  type = string
  description = "Name for public facing ALB"
  default =  "trf-module-alb"
}

variable "disable-interanle-alb" {
  type = bool
  description = "Dsiable internal alb"
  default = false
}

variable "alb-sg" {
}

variable "alb-subnets" {
  
}

variable "pub_sub_alb_tag" {
  default = "two Tier Public Subnet ALB"
  type    = string
}


/*
*****************************************************
                ALB TG VARIABLES
*****************************************************
*/
variable "alb-taget-name" {
  type = string
  default = "trf-modules-alb-tg"
}

variable "tg_port" {}
variable "tg_protocol" {}
variable "vpc_id" {}
variable "alb_hc_interval" {}
variable "alb_hc_path" {}
variable "alb_hc_port" {}
variable "alb_hc_timeout" {}
variable "alb_hc_protocol" {}
variable "alb_hc_matcher" {
  type = string
  default = "200"
}

/*
*****************************************************
                ALB LISTNER VARIABLES
*****************************************************
*/

variable "alb_listener_port" {}
variable "alb_listener_protocol" {}
