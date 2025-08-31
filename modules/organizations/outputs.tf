
output "organization_id" {
  description = "AWS Organizations ID"
  value       = data.aws_organizations_organization.this.id
}

output "root_id" {
  description = "Root ID (e.g., r-abc1)"
  value       = data.aws_organizations_organization.this.roots[0].id
}


output "ou_ids" {
  value       = { for k, v in aws_organizations_organizational_unit.ou : k => v.id }
  description = "Map of OU name -> OU ID"
}

output "policy_arns" {
  value       = { for k, v in aws_organizations_policy.this : k => v.arn }
  description = "Map of policy name -> policy ARN"
}

output "policy_ids" {
  description = "Organization policy IDs created in this module"
  value       = { for k, p in aws_organizations_policy.this : k => p.id }
}
