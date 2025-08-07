variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `api`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/cypik/terraform-aws-guardduty"
  description = "Terraform current module repo"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "info@cypik.com"
  description = "ManagedBy, eg 'info@cypik.com'."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to enable the module"
}

variable "create_bucket" {
  type        = bool
  default     = true
  description = "Whether to create an S3 bucket"
}

variable "bucket_name" {
  type        = string
  default     = null
  description = "Optional bucket name to store GuardDuty lists"
}

variable "guardduty_enable" {
  type        = bool
  default     = true
  description = "Enable GuardDuty"
}

variable "finding_publishing_frequency" {
  type        = string
  default     = "FIFTEEN_MINUTES"
  description = "Frequency of publishing GuardDuty findings"
}

variable "enable_s3_protection" {
  type        = bool
  default     = true
  description = "Enable S3 logs as GuardDuty datasource"
}

variable "enable_kubernetes_protection" {
  type        = bool
  default     = false
  description = "Enable Kubernetes audit logs"
}

variable "enable_malware_protection" {
  type        = bool
  default     = false
  description = "Enable malware protection for EBS volumes"
}

# tflint-ignore: terraform_unused_declarations
variable "ipset_iplist" {
  type        = list(string)
  default     = []
  description = "List of IPs to include in IPSet (string content)"
}

variable "ipset_activate" {
  type        = bool
  default     = false
  description = "Whether to activate the IPSet"
}

variable "ipset_format" {
  type        = string
  default     = "TXT"
  description = "Format of the IPSet file (TXT or STIX)"
}

# tflint-ignore: terraform_unused_declarations
variable "threatintelset_iplist" {
  type        = list(string)
  default     = []
  description = "List of IPs to include in ThreatIntelSet (string content)"
}

variable "threatintelset_activate" {
  type        = bool
  default     = false
  description = "Whether to activate the ThreatIntelSet"
}

variable "threatintelset_format" {
  type        = string
  default     = "TXT"
  description = "Format of the ThreatIntelSet file (TXT or STIX)"
}

variable "organization_auto_enable" {
  type        = bool
  default     = false
  description = "Auto-enable GuardDuty for organization accounts"
}

variable "guardduty_admin_id" {
  type        = string
  default     = null
  description = "Admin account ID for GuardDutyorganization_auto_enable in the org"
}

variable "datasources" {
  type = object({
    s3_logs                = bool
    kubernetes_audit_logs  = bool
    malware_protection_ebs = bool
  })
  default = {
    s3_logs                = true
    kubernetes_audit_logs  = false
    malware_protection_ebs = false
  }
  description = "Auto-enable flags for GuardDuty organization-level datasources"
}

variable "is_guardduty_member" {
  type        = bool
  default     = false
  description = "Whether the current account is a GuardDuty member"
}

variable "member_list" {
  type = list(object({
    account_id = string
    email      = string
    invite     = bool
  }))
  default     = []
  description = "List of GuardDuty member accounts"
}

variable "disable_email_notification" {
  type        = bool
  default     = false
  description = "Disable email notification when inviting member accounts"
}

variable "rule_iam_role_arn" {
  type        = string
  default     = null
  description = "IAM Role ARN for CloudWatch Event Rule"
}

variable "target_iam_role_arn" {
  type        = string
  default     = null
  description = "IAM Role ARN for Event Target to invoke Lambda"
}

variable "slack_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable Slack alerts"
}

variable "slack_webhook_url" {
  type        = string
  description = "Slack Webhook URL"
}

variable "compatible_runtimes" {
  type        = list(any)
  default     = []
  description = "Compatible runtimes for the Lambda layer"
}