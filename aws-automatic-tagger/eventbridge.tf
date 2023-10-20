resource "aws_cloudwatch_event_rule" "sns_event_rule" {
  name          = "rule-sns-topics"
  description   = "Triggers Lambda function when new SNS topic is created"
  is_enabled    = true
  event_pattern = <<EOF
  {
    "detail-type" : ["AWS API Call via CloudTrail"],
    "detail": {
        "eventSource" : ["sns.amazonaws.com"],
        "eventName" : ["CreateTopic"]
    }
  }
  EOF
}

resource "aws_cloudwatch_event_target" "lambda" {
  depends_on = []
  rule       = aws_cloudwatch_event_rule.sns_event_rule.name
  target_id  = "SendToLambda"
  arn        = aws_lambda_function.autolog.arn
}


resource "aws_lambda_permission" "event_birdge_rule" {
  depends_on    = [aws_lambda_function.autolog]
  statement_id  = "AllowExecutionFromEventBridgeRule"
  action        = "lambda:InvokeFunction"
  function_name = var.autotag_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sns_event_rule.arn
}
