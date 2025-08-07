output "slack_alert_lambda_function_name" {
  value = try(module.guardduty.slack_alert_lambda_function_name, null)
}

output "slack_alert_lambda_function_arn" {
  value = try(module.guardduty.slack_alert_lambda_function_arn, null)
}

output "guardduty_detector_id" {
  value = try(module.guardduty.guardduty_detector_id, null)
}