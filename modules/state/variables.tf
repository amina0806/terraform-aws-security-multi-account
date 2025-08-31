variable "name_prefix" {
  type = string
}
variable "region" {
  type = string
}

variable "admin_role_arns" {
  type        = list(string)
  description = "IAM role ARNs that can use the KMS CMK for state"
  default     = []
}
