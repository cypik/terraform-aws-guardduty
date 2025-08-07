provider "aws" {
  region = "us-west-1"
}


module "guardduty" {
  source      = ".././"
  name        = "guardduty"
  environment = "test"
  bucket_name = "guardduty"
  enabled     = true
  compatible_runtimes = [
    ["python3.12", "python3.11"]
  ]
  slack_webhook_url = ""
}