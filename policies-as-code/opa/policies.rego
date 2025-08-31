package terraform.security
violations[msg] if {
	rc := input.resource_changes[_]
	rc.type == "aws_iam_role"
	rc.change
	rc.change.after
	after := rc.change.after
	not after.permissions_boundary
	msg := sprintf("IAM role %q is missing a permissions boundary.", [after.name])
}

violations[msg] if {
	rc := input.resource_changes[_]
	rc.type == "aws_iam_user"
	rc.change
	rc.change.after
	after := rc.change.after
	not after.permissions_boundary
	msg := sprintf("IAM user %q is missing a permissions boundary.", [after.name])
}

violations[msg] if {
	rc := input.resource_changes[_]
	rc.type == "aws_iam_group"
	rc.change
	rc.change.after
	after := rc.change.after
	not after.permissions_boundary
	msg := sprintf("IAM group %q is missing a permissions boundary.", [after.name])
}

violations[msg] if {
	count([1 |
		rc := input.resource_changes[_]
		rc.type == "aws_securityhub_account"
		rc.change
		rc.change.after
	]) == 0
	msg := "Security Hub is not being enabled in this plan (missing aws_securityhub_account)."
}

violations[msg] if {
	count([1 |
		rc := input.resource_changes[_]
		rc.type == "aws_securityhub_standards_subscription"
		rc.change
		rc.change.after
	]) == 0
	msg := "Security Hub has no standards subscription in this plan (e.g., CIS / Foundational)."
}

violations[msg] if {
	count([1 |
		rc := input.resource_changes[_]
		rc.type == "aws_guardduty_detector"
		rc.change
		rc.change.after
	]) == 0
	msg := "GuardDuty is not being enabled in this plan (missing aws_guardduty_detector)."
}

violations[msg] if {
	rc := input.resource_changes[_]
	rc.type == "aws_guardduty_detector"
	rc.change
	rc.change.after
	after := rc.change.after
	not after.enable
	msg := "GuardDuty detector present but 'enable' is false."
}


violations[msg] if {
	input.planned_values
	input.planned_values.root_module
	r := input.planned_values.root_module.resources[_]
	r.type == "aws_s3_bucket"
	r.values.bucket != ""
	not r.values.server_side_encryption_configuration
	msg := sprintf("S3 bucket %q lacks server-side encryption.", [r.values.bucket])
}


passed if count(violations) == 0

messages := [x | violations[x]]

result := {
	"passed": passed,
	"count": count(messages),
	"messages": messages,
}
