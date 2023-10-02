/*
*****************************************************
                ASG VARIABLES
*****************************************************
*/
variable "asg_name" {
  type        = string
  description = "Name for trf module ASG"
  default     = "trf-module-ASG"
}


variable "min-capacity" {
  type        = number
  description = "Min number of EC2 instances in ASG"
  default     = 1
}

variable "max-capacity" {
  type        = number
  description = "Max number of EC2 instances in ASG"
  default     = 2
}

variable "desired-capacity" {
  type        = number
  description = "Desired number of EC2 instance in ASG"
  default     = 1
}

variable "subnet-for-asg" {}


/*
*****************************************************
                LAUNCH TEMPLATE VARIABLES
*****************************************************
*/

variable "lt-asg-name" {
  type    = string
  default = "trf-module-lt-asg"
}

variable "lt-asg-ami" {
  type        = string
  description = "AMI id for EC2 intances"
  default     = "ami-0cea4844b980fe49e"
}

variable "lt-asg-intance-type" {
  type        = string
  description = "Instacne type for launch configuration"
  default     = "t3.micro"
}

variable "lt-instance-sg" {
}

variable "asg_tag_name" {
  default = "two tier asg"
  type    = string
}



/*
*****************************************************
                ASG ATACHMENT VARIABLES
*****************************************************
*/

variable "alb_target_arn" {
  type = string
  description = "ARN for Aplication Load Balnacer to attach to ASG"
}