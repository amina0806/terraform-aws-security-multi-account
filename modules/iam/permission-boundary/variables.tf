variable "name" {
  type        = string
  description = "Name for the permissions boundary policy"
}

variable "allowed_kms_key_arns" {
  type        = list(string)
  default     = []
  description = "KMS keys allowed for S3 PutObject (mirrors SCP)."
}

variable "path" {
  type        = string
  default     = "/permissions-boundary/"
}
