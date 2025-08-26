variable "name_prefix" {
  description = "Prefix for created resources."
  type        = string
  default     = "baseline"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}

variable "config_delivery_bucket_name" {
  description = "Optional explicit name for AWS Config delivery S3 bucket."
  type        = string
  default     = ""
}

variable "conformance_artifacts_bucket_name" {
  description = "Optional explicit name for Conformance Pack artifacts bucket."
  type        = string
  default     = ""
}

variable "conformance_pack_name" {
  description = "Name of the conformance pack to deploy."
  type        = string
  default     = "starter-pack"
}

variable "enable_conformance_pack" {
  description = "Whether to deploy the conformance pack."
  type        = bool
  default     = true
}
