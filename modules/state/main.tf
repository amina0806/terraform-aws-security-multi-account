terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws",
      version = "~> 5.0" }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# Customer-managed KMS key for S3 state encryption
resource "aws_kms_key" "state" {
  description         = "CMK for Terraform state encryption"
  enable_key_rotation = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowAccountRoot"
        Effect   = "Allow"
        Principal= { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowAdminsToUseKey"
        Effect = "Allow"
        Principal = { AWS = var.admin_role_arns }
        Action = [
          "kms:Encrypt","kms:Decrypt","kms:GenerateDataKey*","kms:DescribeKey","kms:ReEncrypt*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "state" {
  name          = "alias/${var.name_prefix}-tfstate"
  target_key_id = aws_kms_key.state.key_id
}

# S3 bucket for remote state
resource "aws_s3_bucket" "state" {
  bucket = "${var.name_prefix}-tfstate-${data.aws_caller_identity.current.account_id}-${var.region}"
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.state.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# TLS-only bucket policy
data "aws_iam_policy_document" "tls_only" {
  statement {
    sid     = "HttpsOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.state.arn,
      "${aws_s3_bucket.state.arn}/*"
    ]
    principals { type = "*"; identifiers = ["*"] }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "state" {
  bucket = aws_s3_bucket.state.id
  policy = data.aws_iam_policy_document.tls_only.json
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "locks" {
  name         = "${var.name_prefix}-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
   name = "LockID";
   type = "S"
  }
}

output "state_bucket"  {
  value = aws_s3_bucket.state.bucket
}
output "lock_table"    {
  value = aws_dynamodb_table.locks.name
}

output "kms_key_arn"   {
  value = aws_kms_key.state.arn
}
