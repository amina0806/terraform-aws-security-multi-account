module "organizations" {
  source = "../../modules/organizations"

  # Adjust as needed
  ou_names        = ["security", "workloads", "sandbox", "infra"]
  allowed_regions = ["us-east-1"]

  attach_to_ous                    = false
  enable_protect_security_services = true
  enable_require_mfa_iam           = false
  enable_deny_root_user            = false
}

data "aws_organizations_policies_for_target" "root_scp" {
  target_id = module.organizations.root_id
  filter    = "SERVICE_CONTROL_POLICY"
}

locals {
  already_attached_ids = toset(data.aws_organizations_policies_for_target.root_scp.ids)
}

resource "aws_organizations_policy_attachment" "root" {
  for_each = {
    for name, id in module.organizations.policy_ids :
    name => id if !(contains(local.already_attached_ids, id))
  }
  policy_id = each.value
  target_id = module.organizations.root_id
}
