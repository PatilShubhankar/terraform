terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13.0"
    }
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region  = "eu-north-1"
  profile = "terraform"
}