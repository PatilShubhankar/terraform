
variable "subnet-counts" {
  type    = list(string)
  default = ["subnet1", "subnet2"]
}

variable "availability-zone" {
  type    = list(string)
  default = ["eu-north-1a", "eu-north-1b"]
}