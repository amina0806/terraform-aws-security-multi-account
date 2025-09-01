## Inputs & Variables

This file lists the common inputs for the Terraform AWS Secure Baseline.

| Variable                       | Type         | Example / Default                     | Purpose |
|--------------------------------|--------------|---------------------------------------|---------|
| `allowed_regions`              | list(string) | `["us-east-1"]`                       | Regions allowed by SCPs |
| `attach_to_ous`                | bool         | `false`                               | Attach SCPs to OUs instead of Root |
| `enable_protect_security_services` | bool     | `true`                                | Deny disabling CloudTrail/Config/GuardDuty/Security Hub |
| `enable_require_mfa_iam`       | bool         | `false`                               | Require MFA for IAM write actions (toggle) |
| `enable_deny_root_user`        | bool         | `false`                               | Deny actions by the root user (break-glass aware) |
| `log_bucket_name`              | string       | `"baseline-log-<acct>-<region>"`      | Centralized CloudTrail/Config bucket |
| `kms_key_alias`                | string       | `"alias/baseline-logs"`               | KMS CMK for logs (and optionally state) |
| `security_hub_standards`       | list(string) | `["cis-1.4.0","afsbp-1.0.0"]`         | Standards to subscribe in Security Hub |
| `guardduty_s3_protection`      | bool         | `true`                                | Enable S3 protection |
| `guardduty_malware_protection` | bool         | `true`                                | Enable EBS malware protection |

---

### Example `envs/dev/terraform.tfvars`

```hcl
allowed_regions            = ["us-east-1"]
attach_to_ous              = false
enable_protect_security_services = true
enable_require_mfa_iam     = false
enable_deny_root_user      = false

log_bucket_name            = "baseline-log-123456789012-us-east-1"
kms_key_alias              = "alias/baseline-logs"

security_hub_standards     = ["cis-1.4.0","afsbp-1.0.0"]
guardduty_s3_protection    = true
guardduty_malware_protection = true
```
