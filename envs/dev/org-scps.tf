variable "enable_org_scps" {
  type    = bool
  default = false # later
}

# Only create the org data when enabled
data "aws_organizations_organization" "org" {
  count = var.enable_org_scps ? 1 : 0
}

locals {
  org_root_id = var.enable_org_scps ? try(data.aws_organizations_organization.org[0].roots[0].id, null) : null
}

module "org_scps" {
  for_each = var.enable_org_scps ? { enabled = true } : {}

  source = "../../modules/org/scps"

  root_id              = local.org_root_id
  target_ou_ids        = []
  target_account_ids   = []
  allowed_kms_key_arns = []

  #enable_cloudtrail_protection = true
  #enable_s3_put_kms_only       = true
}
