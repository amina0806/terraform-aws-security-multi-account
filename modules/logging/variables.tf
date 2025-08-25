variable "name_prefix" {
  description = "Project/owner prefix for names (e.g., amina)"
  type        = string
}

variable "env" {
  description = "Environment name (dev|stage|prod)"
  type        = string
}

variable "log_bucket_name" {
  description = "Optional explicit S3 bucket name for CloudTrail logs"
  type        = string
  default     = null
}

variable "log_group_name_base" {
  description = "Optional override for CW Logs group base (not used yet)"
  type        = string
  default     = null
}

variable "kms_alias" {
  description = "Optional explicit KMS alias for the logging CMK"
  type        = string
  default     = null
}

variable "enable_cloudwatch_logs" {
  description = "If true, also send CloudTrail to CloudWatch Logs"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
