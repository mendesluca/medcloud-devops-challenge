resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}
