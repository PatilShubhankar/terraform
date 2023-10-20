terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region  = "eu-north-1"
  profile = "terraform"

  default_tags {
    tags = {
      Environment = "Dev"
      Project     = "Auto_tag"
    }
  }
}