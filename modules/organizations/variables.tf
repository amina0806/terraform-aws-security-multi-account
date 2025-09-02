variable "ou_names" {
  description = "OU names to create under the root"
  type        = list(string)
  default     = ["security", "workloads", "sandbox", "infra"]
}

variable "allowed_regions" {
  description = "Approved AWS regions"
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
  description = "Require MFA for IAM write operations"
  type        = bool
  default     = false
}

variable "enable_deny_root_user" {
  description = "Deny everything for the root user"
  type        = bool
  default     = false
}

variable "attach_to_root" {
  type    = bool
  default = false
}
