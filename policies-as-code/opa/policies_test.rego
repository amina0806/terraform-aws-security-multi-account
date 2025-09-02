package terraform.security

no_violations_for(inp) if {

	n := count([x | data.terraform.security.violations[x] with input as inp])
	n == 0
}

test_iam_role_missing_boundary_denies if {
	inp := {"resource_changes": [{"type": "aws_iam_role", "change": {"after": {"name": "r1"}}}]}
	data.terraform.security.violations["IAM role \"r1\" is missing a permissions boundary."] with input as inp
}

test_iam_user_missing_boundary_denies if {
	inp := {"resource_changes": [{"type": "aws_iam_user", "change": {"after": {"name": "u1"}}}]}
	data.terraform.security.violations["IAM user \"u1\" is missing a permissions boundary."] with input as inp
}

test_iam_group_missing_boundary_denies if {
	inp := {"resource_changes": [{"type": "aws_iam_group", "change": {"after": {"name": "g1"}}}]}
	data.terraform.security.violations["IAM group \"g1\" is missing a permissions boundary."] with input as inp
}


test_securityhub_both_missing_denies if {
	inp := {"resource_changes": []}
	data.terraform.security.violations["Security Hub is not being enabled in this plan (missing aws_securityhub_account)."] with input as inp
	data.terraform.security.violations["Security Hub has no standards subscription in this plan (e.g., CIS / Foundational)."] with input as inp
}

test_securityhub_account_only_denies_subscription if {
	inp := {"resource_changes": [{"type": "aws_securityhub_account", "change": {"after": {}}}]}
	data.terraform.security.violations["Security Hub has no standards subscription in this plan (e.g., CIS / Foundational)."] with input as inp
}

test_guardduty_missing_detector_denies if {
	inp := {"resource_changes": []}
	data.terraform.security.violations["GuardDuty is not being enabled in this plan (missing aws_guardduty_detector)."] with input as inp
}

test_guardduty_disabled_denies if {
	inp := {"resource_changes": [{"type": "aws_guardduty_detector", "change": {"after": {"enable": false}}}]}
	data.terraform.security.violations["GuardDuty detector present but 'enable' is false."] with input as inp
}

test_all_enabled_allows if {
	inp := {
		"resource_changes": [
			{"type": "aws_iam_role", "change": {"after": {"name": "ok-role", "permissions_boundary": "pb"}}},
			{"type": "aws_securityhub_account", "change": {"after": {}}},
			{"type": "aws_securityhub_standards_subscription", "change": {"after": {}}},
			{"type": "aws_guardduty_detector", "change": {"after": {"enable": true}}},
		],
		"planned_values": {"root_module": {"resources": [{
			"type": "aws_s3_bucket",
			"values": {
				"bucket": "ok-sse",
				"server_side_encryption_configuration": {"rule": [{"apply_server_side_encryption_by_default": {"sse_algorithm": "aws:kms"}}]},
			},
		}]}},
	}
	no_violations_for(inp)
}


test_s3_requires_sse_denies if {
	inp := {"planned_values": {"root_module": {"resources": [{"type": "aws_s3_bucket", "values": {"bucket": "no-sse"}}]}}}
	data.terraform.security.violations["S3 bucket \"no-sse\" lacks server-side encryption."] with input as inp
}


test_s3_with_sse_allows if {
	inp := {
		"resource_changes": [
			{"type": "aws_securityhub_account", "change": {"after": {}}},
			{"type": "aws_securityhub_standards_subscription", "change": {"after": {}}},
			{"type": "aws_guardduty_detector", "change": {"after": {"enable": true}}},
		],
		"planned_values": {"root_module": {"resources": [{
			"type": "aws_s3_bucket",
			"values": {
				"bucket": "ok-sse",
				"server_side_encryption_configuration": {"rule": [{"apply_server_side_encryption_by_default": {"sse_algorithm": "aws:kms"}}]},
			},
		}]}},
	}
	no_violations_for(inp)
}
