
variable "region" {
  description = "AWS region in which resources will be deployed"
  type        = string
  default     = "eu-north-1"
}

variable "ec2-ami-id" {
  type    = string
  default = "ami-0cea4844b980fe49e"
}