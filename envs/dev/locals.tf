locals {
  name_prefix = "amina-dev"

  tags = {
    Project = "tf-aws-secure-baseline"
    Env     = var.env
    Owner   = "amina"
  }
}
