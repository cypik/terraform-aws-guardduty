# Terraform-Aws-Guardduty

# Terraform AWS Cloud Guardduty Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [License](#license)
- [Author](#Author)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This Terraform module creates an AWS Elastic Compute Cloud (Guardduty) along with additional configuration options.
## Usage
To use this module, you should have Terraform installed and configured for AWS. This module provides the necessary Terraform configuration for creating AWS resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Examples

# Example: guardduty

```hcl
module "guardduty" {
  source      = "cypik/guardduty/aws"
  version     = "1.0.0"
  name        = "guardduty"
  environment = "test"
  bucket_name = "guardduty"
  enabled     = true
  compatible_runtimes = [
    ["python3.12", "python3.11"]
  ]
  slack_webhook_url = ""
}
```

This example demonstrates how to create various AWS resources using the provided modules. Adjust the input values to suit your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-aws-guardduty/tree/master/example) directory within this repository.

## License
This Terraform module is provided under the **MIT** License. Please see the [LICENSE](https://github.com/cypik/terraform-aws-guardduty/blob/master/LICENSE) file for more details.

## Author
Your Name
Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/aws | 1.0.2 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | cypik/s3/aws | 1.0.3 |
| <a name="module_slack-alert"></a> [slack-alert](#module\_slack-alert) | cypik/slack-notification/aws | 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_guardduty_detector.detector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_invite_accepter.member_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_invite_accepter) | resource |
| [aws_guardduty_ipset.ipset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_ipset) | resource |
| [aws_guardduty_member.member](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_member) | resource |
| [aws_guardduty_organization_admin_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_admin_account) | resource |
| [aws_guardduty_organization_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration) | resource |
| [aws_guardduty_threatintelset.threatintelset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_threatintelset) | resource |
| [aws_s3_bucket_object.ipset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_object.threatintelset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_policy.guardduty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Optional bucket name to store GuardDuty lists | `string` | `null` | no |
| <a name="input_compatible_runtimes"></a> [compatible\_runtimes](#input\_compatible\_runtimes) | Compatible runtimes for the Lambda layer | `list(any)` | `[]` | no |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | Whether to create an S3 bucket | `bool` | `true` | no |
| <a name="input_datasources"></a> [datasources](#input\_datasources) | Auto-enable flags for GuardDuty organization-level datasources | <pre>object({<br>    s3_logs                = bool<br>    kubernetes_audit_logs  = bool<br>    malware_protection_ebs = bool<br>  })</pre> | <pre>{<br>  "kubernetes_audit_logs": false,<br>  "malware_protection_ebs": false,<br>  "s3_logs": true<br>}</pre> | no |
| <a name="input_disable_email_notification"></a> [disable\_email\_notification](#input\_disable\_email\_notification) | Disable email notification when inviting member accounts | `bool` | `false` | no |
| <a name="input_enable_kubernetes_protection"></a> [enable\_kubernetes\_protection](#input\_enable\_kubernetes\_protection) | Enable Kubernetes audit logs | `bool` | `false` | no |
| <a name="input_enable_malware_protection"></a> [enable\_malware\_protection](#input\_enable\_malware\_protection) | Enable malware protection for EBS volumes | `bool` | `false` | no |
| <a name="input_enable_s3_protection"></a> [enable\_s3\_protection](#input\_enable\_s3\_protection) | Enable S3 logs as GuardDuty datasource | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to enable the module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input\_finding\_publishing\_frequency) | Frequency of publishing GuardDuty findings | `string` | `"FIFTEEN_MINUTES"` | no |
| <a name="input_guardduty_admin_id"></a> [guardduty\_admin\_id](#input\_guardduty\_admin\_id) | Admin account ID for GuardDutyorganization\_auto\_enable in the org | `string` | `null` | no |
| <a name="input_guardduty_enable"></a> [guardduty\_enable](#input\_guardduty\_enable) | Enable GuardDuty | `bool` | `true` | no |
| <a name="input_ipset_activate"></a> [ipset\_activate](#input\_ipset\_activate) | Whether to activate the IPSet | `bool` | `false` | no |
| <a name="input_ipset_format"></a> [ipset\_format](#input\_ipset\_format) | Format of the IPSet file (TXT or STIX) | `string` | `"TXT"` | no |
| <a name="input_ipset_iplist"></a> [ipset\_iplist](#input\_ipset\_iplist) | List of IPs to include in IPSet (string content) | `list(string)` | `[]` | no |
| <a name="input_is_guardduty_member"></a> [is\_guardduty\_member](#input\_is\_guardduty\_member) | Whether the current account is a GuardDuty member | `bool` | `false` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'info@cypik.com'. | `string` | `"info@cypik.com"` | no |
| <a name="input_member_list"></a> [member\_list](#input\_member\_list) | List of GuardDuty member accounts | <pre>list(object({<br>    account_id = string<br>    email      = string<br>    invite     = bool<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `api`). | `string` | `""` | no |
| <a name="input_organization_auto_enable"></a> [organization\_auto\_enable](#input\_organization\_auto\_enable) | Auto-enable GuardDuty for organization accounts | `bool` | `false` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/cypik/terraform-aws-guardduty"` | no |
| <a name="input_rule_iam_role_arn"></a> [rule\_iam\_role\_arn](#input\_rule\_iam\_role\_arn) | IAM Role ARN for CloudWatch Event Rule | `string` | `null` | no |
| <a name="input_slack_enabled"></a> [slack\_enabled](#input\_slack\_enabled) | Whether to enable Slack alerts | `bool` | `true` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack Webhook URL | `string` | n/a | yes |
| <a name="input_target_iam_role_arn"></a> [target\_iam\_role\_arn](#input\_target\_iam\_role\_arn) | IAM Role ARN for Event Target to invoke Lambda | `string` | `null` | no |
| <a name="input_threatintelset_activate"></a> [threatintelset\_activate](#input\_threatintelset\_activate) | Whether to activate the ThreatIntelSet | `bool` | `false` | no |
| <a name="input_threatintelset_format"></a> [threatintelset\_format](#input\_threatintelset\_format) | Format of the ThreatIntelSet file (TXT or STIX) | `string` | `"TXT"` | no |
| <a name="input_threatintelset_iplist"></a> [threatintelset\_iplist](#input\_threatintelset\_iplist) | List of IPs to include in ThreatIntelSet (string content) | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_detector_id"></a> [guardduty\_detector\_id](#output\_guardduty\_detector\_id) | GuardDuty detector ID |
| <a name="output_guardduty_ipset_id"></a> [guardduty\_ipset\_id](#output\_guardduty\_ipset\_id) | GuardDuty IPSet ID |
| <a name="output_guardduty_threatintelset_id"></a> [guardduty\_threatintelset\_id](#output\_guardduty\_threatintelset\_id) | GuardDuty ThreatIntelSet ID |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | GuardDuty S3 bucket name |
| <a name="output_slack_alert_lambda_function_arn"></a> [slack\_alert\_lambda\_function\_arn](#output\_slack\_alert\_lambda\_function\_arn) | Lambda function ARN for Slack alerting |
| <a name="output_slack_alert_lambda_function_name"></a> [slack\_alert\_lambda\_function\_name](#output\_slack\_alert\_lambda\_function\_name) | Lambda function name for Slack alerting |
<!-- END_TF_DOCS -->