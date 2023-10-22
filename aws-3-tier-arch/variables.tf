#Variable for AWS AZs

variable "aws-availability-zone" {
  type        = list(string)
  description = "AZs avialable for subnet"
  default     = ["eu-north-1a", "eu-north-1b"]
}