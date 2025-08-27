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
}

variable "name_prefix" {
  type = string
}

variable "admin_role_arns" {
  type    = list(string)
  default = []
}
