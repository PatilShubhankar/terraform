terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.3.0"
    }
  }
  required_version = "~> 1.5.0"
  backend "s3" {
    bucket = "dev-shubhankar-remote-state-bucket"
    key = "terraform.tfstate"
    region = "eu-north-1"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  profile = "terraform"
  region  = "eu-north-1"
}