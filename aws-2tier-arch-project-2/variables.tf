
variable "region" {
  description = "AWS region in which resources will be deployed"
  type        = string
  default     = "eu-north-1"
}

variable "number-of-subnet" {
  description = "Number of subnet in this VPC"
  type        = number
  default     = 2
}

variable "availability-zone" {
  description = "Avaliability zone on eu-north-1 Region"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}