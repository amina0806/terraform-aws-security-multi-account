output "securityhub_enabled" {
  description = "Was Security Hub enabled"
  value       = length(aws_securityhub_account.this) > 0
}

output "enabled_security_standards" {
  description = "Security Hub standards ARNs subscribed"
  value       = [for s in aws_securityhub_standards_subscription.this : s.standards_arn]
}

output "guardduty_detector_id" {
  description = "GuardDuty detector ID (if enabled)"
  value       = try(aws_guardduty_detector.this[0].id, null)
}

output "guardduty_finding_publish_arn" {
  description = "GuardDuty detector ARN (if enabled)"
  value       = try(aws_guardduty_detector.this[0].arn, null)
}
