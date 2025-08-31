variable "ou_names" {
  description = "OU names to create under the root"
  type        = list(string)
  default     = ["security", "workloads", "sandbox", "infra"]
}

variable "allowed_regions" {
  description = "Approved AWS regions (restricts all others). Leave as [\"us-east-1\"] for your lab."
  type        = list(string)
  default     = ["us-east-1"]
}

variable "attach_to_ous" {
  description = "Also attach the policies to all OUs"
  type        = bool
  default     = false
}

variable "enable_protect_security_services" {
  description = "Protect CloudTrail/Config/GuardDuty/SecurityHub from disable/delete"
  type        = bool
  default     = true
}

variable "enable_require_mfa_iam" {
  description = "Require MFA for IAM write operations (enable AFTER you use MFA sessions)"
  type        = bool
  default     = false
}

variable "enable_deny_root_user" {
  description = "Deny everything for the root user (DANGEROUS—enable only with break-glass plan)"
  type        = bool
  default     = false
}

variable "attach_to_root" {
  type    = bool
  default = false
}
