output "state_bucket_name" {
  value       = aws_s3_bucket.state.bucket
  description = "Use this in backend.tf as bucket"
}

output "lock_table_name" {
  value       = aws_dynamodb_table.locks.name
  description = "Use this in backend.tf as dynamodb_table"
}

output "kms_key_arn" {
  value       = aws_kms_key.tf_state.arn
  description = "Use this in backend.tf as kms_key_id"
}
