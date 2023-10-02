
variable "region" {
  description = "AWS region in which resources will be deployed"
  type        = string
  default     = "eu-north-1"
}

variable "ec2-ami-id" {
  type    = string
  default = "ami-0989fb15ce71ba39e"
}