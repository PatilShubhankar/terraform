variable "aws_region" {
  type        = string
  default     = "eu-north-1"
  description = "regions my resources will be deployed"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  type        = string
  default     = "ami-0716e5989a4e4fa52"
}

variable "key_name" {
  type        = string
  default     = "myec2key"
}

variable "s3bucket" {
  type        = string
  default     = "jenkins-bucket-31032023369432"
}

variable "acl" {
  type        = string
  default     = "private"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-00bc38a43c4f87d50"
}


