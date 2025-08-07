output "guardduty_detector_id" {
  value       = try(aws_guardduty_detector.detector[0].id, null)
  description = "GuardDuty detector ID"
}

output "guardduty_ipset_id" {
  value       = try(aws_guardduty_ipset.ipset[0].id, null)
  description = "GuardDuty IPSet ID"
}

output "guardduty_threatintelset_id" {
  value       = try(aws_guardduty_threatintelset.threatintelset[0].id, null)
  description = "GuardDuty ThreatIntelSet ID"
}

output "s3_bucket_name" {
  value       = try(module.s3_bucket[0].id, null)
  description = "GuardDuty S3 bucket name"
}

output "slack_alert_lambda_function_name" {
  value       = try(module.slack-alert[0].lambda_function_name, null)
  description = "Lambda function name for Slack alerting"
}

output "slack_alert_lambda_function_arn" {
  value       = try(module.slack-alert[0].lambda_function_arn, null)
  description = "Lambda function ARN for Slack alerting"
}