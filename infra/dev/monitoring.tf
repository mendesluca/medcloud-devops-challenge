resource "aws_sns_topic" "alerts" {
  name = "todo-api-alerts-${terraform.workspace}"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "mendes.lucasm740@gmail.com"
}
