data "aws_caller_identity" "current" {}

locals {
  ipset_key          = "ipset.txt"
  threatintelset_key = "threatintelset.txt"
  bucket_name        = coalesce(var.bucket_name, try(module.s3_bucket[0].id, ""))
}

module "labels" {
  source      = "cypik/labels/aws"
  version     = "1.0.2"
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

module "s3_bucket" {
  source  = "cypik/s3/aws"
  version = "1.0.3"
  count   = var.enabled && var.create_bucket ? 1 : 0

  s3_name                 = coalesce(var.bucket_name, "secure-baseline-guardduty")
  force_destroy           = false
  versioning              = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "guardduty" {
  count  = var.enabled ? 1 : 0
  bucket = local.bucket_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowGuardDutyRead",
        Effect    = "Allow",
        Principal = { Service = "guardduty.amazonaws.com" },
        Action    = "s3:GetObject",
        Resource = [
          "arn:aws:s3:::${local.bucket_name}/${local.ipset_key}",
          "arn:aws:s3:::${local.bucket_name}/${local.threatintelset_key}"
        ]
      }
    ]
  })
}

resource "aws_guardduty_detector" "detector" {
  count                        = var.enabled ? 1 : 0
  enable                       = var.guardduty_enable
  finding_publishing_frequency = var.finding_publishing_frequency

  datasources {
    s3_logs {
      enable = var.enable_s3_protection
    }
    kubernetes {
      audit_logs {
        enable = var.enable_kubernetes_protection
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.enable_malware_protection
        }
      }
    }
  }
}

resource "aws_guardduty_invite_accepter" "member_accepter" {
  count             = var.enabled && var.is_guardduty_member ? 1 : 0
  detector_id       = join("", aws_guardduty_detector.detector[*].id)
  master_account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket_object" "ipset" {
  count   = var.enabled ? 1 : 0
  acl     = "private"
  content = "${path.module}/templates/ipset.txt.tpl"

  bucket        = local.bucket_name
  key           = local.ipset_key
  force_destroy = true
  tags          = module.labels.tags
}

resource "aws_guardduty_ipset" "ipset" {
  count       = var.enabled && var.ipset_activate ? 1 : 0
  name        = format("%s-ipset-private", module.labels.id)
  activate    = var.ipset_activate
  detector_id = aws_guardduty_detector.detector[0].id
  format      = var.ipset_format
  location    = "https://s3.amazonaws.com/${aws_s3_bucket_object.ipset[0].bucket}/${aws_s3_bucket_object.ipset[0].key}"

  depends_on = [
    aws_s3_bucket_object.ipset,
    aws_s3_bucket_policy.guardduty
  ]
}

resource "aws_s3_bucket_object" "threatintelset" {
  count   = var.enabled ? 1 : 0
  acl     = "private"
  content = "${path.module}/templates/threatintelset.txt.tpl"


  bucket        = local.bucket_name
  key           = local.threatintelset_key
  force_destroy = true
  tags          = module.labels.tags
}

resource "aws_guardduty_threatintelset" "threatintelset" {
  count       = var.enabled && var.threatintelset_activate ? 1 : 0
  name        = format("%s-threat", module.labels.id)
  activate    = var.threatintelset_activate
  detector_id = aws_guardduty_detector.detector[0].id
  format      = var.threatintelset_format
  location    = "https://s3.amazonaws.com/${aws_s3_bucket_object.threatintelset[0].bucket}/${aws_s3_bucket_object.threatintelset[0].key}"

  depends_on = [
    aws_s3_bucket_object.threatintelset,
    aws_s3_bucket_policy.guardduty
  ]
}

resource "aws_guardduty_organization_admin_account" "default" {
  count            = var.enabled && var.organization_auto_enable ? 1 : 0
  admin_account_id = coalesce(var.guardduty_admin_id, data.aws_caller_identity.current.account_id)

  depends_on = [aws_guardduty_detector.detector]
}

resource "aws_guardduty_organization_configuration" "default" {
  count                            = var.enabled && var.organization_auto_enable ? 1 : 0
  auto_enable_organization_members = var.organization_auto_enable
  detector_id                      = aws_guardduty_detector.detector[0].id

  datasources {
    s3_logs {
      auto_enable = var.datasources.s3_logs
    }
    kubernetes {
      audit_logs {
        enable = var.datasources.kubernetes_audit_logs
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = var.datasources.malware_protection_ebs
        }
      }
    }
  }
}

resource "aws_guardduty_member" "member" {
  count                      = var.enabled && var.is_guardduty_member ? length(var.member_list) : 0
  account_id                 = var.member_list[count.index]["account_id"]
  detector_id                = aws_guardduty_detector.detector[0].id
  email                      = var.member_list[count.index]["email"]
  invite                     = var.member_list[count.index]["invite"]
  invitation_message         = "Please accept guardduty invitation"
  disable_email_notification = var.disable_email_notification
}

resource "aws_cloudwatch_event_rule" "default" {
  count       = var.enabled ? 1 : 0
  name        = format("%s-er", module.labels.id)
  description = "Event rule for AWS Guarddduty."
  role_arn    = var.rule_iam_role_arn
  is_enabled  = var.enabled
  tags        = module.labels.tags

  event_pattern = <<EOF
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"]
}
EOF
}

resource "aws_cloudwatch_event_target" "default" {
  count     = var.enabled && var.slack_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.default[0].name
  target_id = "Guardduty"
  arn       = module.slack-alert[0].lambda_function_arn
  role_arn  = var.target_iam_role_arn
}

module "slack-alert" {
  source  = "cypik/slack-notification/aws"
  version = "1.0.1"
  #  source = "modules/lambda_packages"
  count                             = var.enabled && var.slack_enabled ? 1 : 0
  name                              = format("%s-slack-notification", module.labels.id)
  filename                          = "${path.module}/modules/lambda_packages/index.zip"
  layer_filenames                   = ["${path.module}/modules/lambda_packages/layer.zip"]
  handler                           = "lambda_function.lambda_handler"
  runtime                           = "python3.9"
  compatible_architectures          = ["x86_64"]
  timeout                           = 10
  cloudwatch_logs_retention_in_days = 7
  source_arns                       = [aws_cloudwatch_event_rule.default[0].arn]
  iam_actions                       = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
  compatible_runtimes               = var.compatible_runtimes
  actions                           = ["lambda:InvokeFunction"]
  principals                        = ["s3.amazonaws.com"]
  statement_ids                     = ["AllowExecutionFromS3"]
  SLACK_WEBHOOK_URL                 = var.slack_webhook_url
}