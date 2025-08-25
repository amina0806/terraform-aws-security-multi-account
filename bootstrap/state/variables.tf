variable "region" {
  description = "AWS region for the state backend resources"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally-unique S3 bucket name for Terraform remote state"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "terraform-state-locks"
}

variable "kms_alias" {
  description = "KMS alias for the state CMK"
  type        = string
  default     = "alias/tf-state"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {
    Project = "tf-aws-secure-baseline"
    Purpose = "terraform-state"
    Owner   = "amina"
  }
}
