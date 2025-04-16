terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "vpc-${terraform.workspace}"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = terraform.workspace
    Project     = var.project
  }
}

module "ecs_cluster" {
  source       = "../modules/ecs"
  cluster_name = "cluster-${terraform.workspace}"
  environment  = terraform.workspace
  project      = var.project
}

module "ecr" {
  source          = "../modules/ecr"
  repository_name = "todo-api-${terraform.workspace}"
  environment     = terraform.workspace
  project         = var.project
}

module "alb" {
  source  = "../modules/alb"
  name    = "todo-api-${terraform.workspace}"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  tags = {
    Environment = terraform.workspace
    Project     = var.project
  }
}

module "artifacts_bucket" {
  source       = "../modules/s3_artifacts"
  bucket_name  = "todo-api-artifacts-${terraform.workspace}-lucas"
  environment  = terraform.workspace
  project      = var.project
}

module "pipeline" {
  source                = "../modules/pipeline"
  environment           = terraform.workspace
  ecr_url               = module.ecr.repository_url
  cluster_name          = module.ecs_cluster.cluster_id
  service_name          = aws_ecs_service.todo_api.name
  github_connection_arn = "arn:aws:codestar-connections:us-east-1:975049932664:connection/e361281e-e36a-4269-9bac-5b19077ea02f"
  github_full_repo      = "mendesluca/todo-api"
  github_branch         = "main"
  github_repo_url       = "https://github.com/mendesluca/todo-api.git"
  s3_bucket             = module.artifacts_bucket.bucket_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole-${terraform.workspace}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole-${terraform.workspace}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg-${terraform.workspace}"
  description = "Security group for ECS service"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg-${terraform.workspace}"
  }
}

resource "aws_ecs_task_definition" "todo_api" {
  family                   = "todo-api-${terraform.workspace}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "todo-api",
      image     = module.ecr.repository_url,
      essential = true,
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 3000
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/todo-api-${terraform.workspace}",
          awslogs-region        = var.aws_region,
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "todo_api" {
  name            = "todo-api-${terraform.workspace}"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.todo_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.public_subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arn
    container_name   = "todo-api"
    container_port   = 3000
  }

  depends_on = [
    aws_ecs_task_definition.todo_api,
    module.alb
  ]
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "todo-api-${terraform.workspace}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarme quando uso de CPU passa de 70% no ECS"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = module.ecs_cluster.cluster_id
    ServiceName = aws_ecs_service.todo_api.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]

  tags = {
    Environment = terraform.workspace
    Project     = var.project
  }
}
