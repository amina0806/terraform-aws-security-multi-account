
variable "name_prefix" {
  description = "Prefix for naming (tags, optional resource names)"
  type        = string
  default     = "amina-dev"
}

variable "enable_security_hub" {
  description = "Enable AWS Security Hub in this account/region"
  type        = bool
  default     = true
}

variable "enable_security_hub_cis" {
  description = "Subscribe to CIS AWS Foundations"
  type        = bool
  default     = true
}

variable "cis_version" {
  description = "CIS AWS Foundations version string"
  type        = string
  default     = "1.4.0"
}

variable "enable_security_hub_afsbp" {
  description = "Subscribe to AWS Foundational Security Best Practices (AFSBP)"
  type        = bool
  default     = true
}

variable "afsbp_version" {
  description = "AFSBP version string"
  type        = string
  default     = "1.0.0"
}

variable "enable_security_hub_nist" {
  description = "Subscribe to NIST 800-53 rev 5"
  type        = bool
  default     = true
}

variable "enable_guardduty" {
  description = "Enable GuardDuty detector in this account/region"
  type        = bool
  default     = true
}

variable "gd_enable_s3_protection" {
  description = "GuardDuty S3 logs protection"
  type        = bool
  default     = true
}

variable "gd_enable_eks_audit_logs" {
  description = "GuardDuty EKS audit logs detection"
  type        = bool
  default     = false
}

variable "gd_enable_malware_protection_ebs" {
  description = "GuardDuty EC2 Malware Protection (EBS volumes)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
