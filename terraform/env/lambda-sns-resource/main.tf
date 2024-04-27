# LB
resource "aws_lb" "alarm_test_lb" {
  name               = "alarm-exec-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = ["${var.subnet_id_1}", "${var.subnet_id_2}"]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "alarm_nlb_tg" {
  name     = "alarm-exec-nlb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id 
}

# cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "error_rate" {
  alarm_name                = "error-rate"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "UnHealthyHostCount"
  namespace                 = "AWS/NetworkELB"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "0"
  datapoints_to_alarm       = 1
  alarm_description         = "This metric monitors Error rate"
  insufficient_data_actions = []

  dimensions = {
    LoadBalancer = aws_lb.alarm_test_lb.id
  }

  alarm_actions = [aws_sns_topic.alarm_topic.arn]
}

# SNS Topic
resource "aws_sns_topic" "alarm_topic" {
  name = "cloudwatch-alarm-sns-topic"
}

resource "aws_sns_topic_policy" "alarm_topic_policy" {
  arn    = aws_sns_topic.alarm_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.example_lambda.arn
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    actions = [
      "SNS:Publish",
    ]

    effect    = "Allow"
    resources = [aws_sns_topic.alarm_topic.arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceOrgID"
      values   = [var.ouid]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
  }
}

# Lambda
resource "aws_lambda_function" "example_lambda" {
  filename         = "lambda_function_payload.zip"
  function_name    = "example_lambda_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "python3.8"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      HELLO = "World"
    }
  }
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alarm_topic.arn
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_logs" {
  name        = "lambda_logging_policy"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}
