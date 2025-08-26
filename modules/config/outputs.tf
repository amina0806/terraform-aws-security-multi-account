output "config_delivery_bucket" {
  description = "S3 bucket used by AWS Config delivery"
  value       = aws_s3_bucket.config_delivery.bucket
}

output "conformance_artifacts_bucket" {
  description = "S3 bucket used by Conformance Pack artifacts"
  value       = aws_s3_bucket.conformance_artifacts.bucket
}

output "conformance_pack_name" {
  description = "Name of the deployed conformance pack (if enabled)"
  value       = var.enable_conformance_pack ? var.conformance_pack_name : null
}
