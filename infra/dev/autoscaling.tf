resource "aws_appautoscaling_target" "ecs_scaling_target" {
  service_namespace  = "ecs"
  resource_id = "service/${module.ecs_cluster.cluster_name}/todo-api-${var.environment}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 3
}

resource "aws_appautoscaling_policy" "cpu_scale_out" {
  name               = "cpu-scale-out-${terraform.workspace}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id 
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
