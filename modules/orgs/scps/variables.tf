variable "root_id" {
  description = "Organizations Root ID (e.g., r-xxxx). Pass from env via data.aws_organizations_organization."
  type        = string
}

variable "target_ou_ids" {
  description = "Optional list of OU IDs to attach SCPs to (besides root)."
  type        = list(string)
  default     = []
}

variable "target_account_ids" {
  description = "Optional list of Account IDs to attach SCPs to directly."
  type        = list(string)
  default     = []
}

variable "allowed_kms_key_arns" {
  description = "List of KMS Key ARNs that are allowed for S3 PutObject."
  type        = list(string)
  default     = []
}

variable "enable_cloudtrail_protection" {
  description = "Also deny actions that disable / delete CloudTrail."
  type        = bool
  default     = true
}
