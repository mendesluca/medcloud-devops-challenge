resource "aws_iam_role" "eventbridge_ecs_role" {
  name = "eventbridge-ecs-role-${terraform.workspace}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_ecs_policy" {
  role = aws_iam_role.eventbridge_ecs_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_event_rule" "ecs_stop" {
  name                = "ecs-stop-${terraform.workspace}"
  schedule_expression = "cron(0 22 * * ? *)"
}

resource "aws_cloudwatch_event_rule" "ecs_start" {
  name                = "ecs-start-${terraform.workspace}"
  schedule_expression = "cron(0 7 * * ? *)"
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.ecs_stop.name
  role_arn  = aws_iam_role.eventbridge_ecs_role.arn
  arn       = "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/cluster-${terraform.workspace}"

  ecs_target {
    # task_count = 0
    launch_type      = "FARGATE"
    platform_version = "LATEST"
    network_configuration {
      subnets          = module.vpc.public_subnets
      assign_public_ip = true
      security_groups  = [aws_security_group.ecs_sg.id]
    }
    task_definition_arn = aws_ecs_task_definition.todo_api.arn
  }
}

resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.ecs_start.name
  role_arn  = aws_iam_role.eventbridge_ecs_role.arn
  arn       = "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/cluster-${terraform.workspace}"

  ecs_target {
    task_count       = 1
    launch_type      = "FARGATE"
    platform_version = "LATEST"
    network_configuration {
      subnets          = module.vpc.public_subnets
      assign_public_ip = true
      security_groups  = [aws_security_group.ecs_sg.id]
    }
    task_definition_arn = aws_ecs_task_definition.todo_api.arn
  }
}

data "aws_caller_identity" "current" {}
