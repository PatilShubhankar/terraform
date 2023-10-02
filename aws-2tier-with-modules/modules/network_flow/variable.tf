/*
*****************************************************
                 VPC VARIABLES
*****************************************************
*/
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_hostname" {
  type    = bool
  default = true
}

variable "vpc_name" {
  type    = string
  default = "Two-Tier-Vpc"
}


/*
*****************************************************
                 SUBNET VARIABLES
*****************************************************
*/
variable "pub_subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "map_public_ip" {
  type    = bool
  default = true
}

variable "subnet_az" {
  type    = string
  default = "eu-north-1a"
}

variable "subent_name" {
  type    = string
  default = "public-subnet"
}