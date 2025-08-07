import json
import os
import urllib3
import logging

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

http = urllib3.PoolManager()

def lambda_handler(event, context):
    webhook_url = os.environ.get('SLACK_WEBHOOK_URL')

    if not webhook_url:
        logger.error("SLACK_WEBHOOK_URL not set")
        return {
            "statusCode": 500,
            "body": json.dumps("Slack webhook URL not configured.")
        }

    message = {
        "text": ":rotating_light: *GuardDuty Alert:* \n```" + json.dumps(event, indent=2) + "```"
    }

    try:
        response = http.request(
            "POST",
            webhook_url,
            body=json.dumps(message).encode("utf-8"),
            headers={'Content-Type': 'application/json'}
        )

        logger.info(f"Slack response: {response.status}")

        if response.status != 200:
            return {
                "statusCode": response.status,
                "body": json.dumps("Failed to send Slack notification.")
            }

        return {
            "statusCode": 200,
            "body": json.dumps("Notification sent to Slack!")
        }

    except Exception as e:
        logger.error(f"Exception occurred: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps("Error sending Slack notification.")
        }
