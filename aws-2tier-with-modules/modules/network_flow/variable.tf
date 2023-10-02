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

/*
*****************************************************
                 GATEWAY VARIABLES
*****************************************************
*/
variable "igw-name" {
  type    = string
  default = "public-igw"
}


/*
*****************************************************
                 ROUTE-TABLE VARIABLES
*****************************************************
*/

variable "public-rt-cidr" {
  type        = string
  description = "CIDR block to route traffic from anywhere to intergateway"
  default     = "0.0.0.0/0"
}

variable "public-route-table-name" {
  type        = string
  description = "Name for public route table"
  default     = "public-route-table"
}

/*
*****************************************************
                SECURITY GROUP VARIABLES
*****************************************************
*/
variable "alb-sg-name" {
  type        = string
  description = "Name for security group ALB"
  default     = "alb-security-group"
}

variable "asg-sg-name" {
  type        = string
  description = "Name for security group ASG"
  default     = "asg-security-group"
}

variable "db-sg-name" {
  type        = string
  description = "Name for security group DB"
  default     = "db-security-group"
}

/*
*****************************************************
                AVAILABLITY ZONE VARIABLES
*****************************************************
*/

variable "availability_zones" {
  type        = list(string)
  description = "List of AWS availablity zones"
  default     = ["eu-north-1a", "eu-north-1b"]
}