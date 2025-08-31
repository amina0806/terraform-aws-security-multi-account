terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner       = "amina"
      Environment = var.env
      DataClass   = "Internal"
      Project     = "tf-aws-secure-baseline"
    }
  }
}
