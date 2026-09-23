# ============================================================
# ECS SERVICE AUTO SCALING TARGET
# ============================================================

resource "aws_appautoscaling_target" "neonlens" {
  count = var.enable_autoscaling ? 1 : 0

  max_capacity = var.autoscaling_max_capacity
  min_capacity = var.autoscaling_min_capacity

  resource_id = "service/${aws_ecs_cluster.neonlens.name}/${aws_ecs_service.neonlens.name}"

  scalable_dimension = "ecs:service:DesiredCount"

  service_namespace = "ecs"

  depends_on = [
    aws_ecs_cluster.neonlens,
    aws_ecs_service.neonlens
  ]
}


# ============================================================
# CPU TARGET TRACKING
# ============================================================

resource "aws_appautoscaling_policy" "neonlens_cpu" {
  count = var.enable_autoscaling && var.enable_cpu_autoscaling ? 1 : 0

  name = "${local.name_prefix}-cpu-scaling"

  policy_type = "TargetTrackingScaling"

  service_namespace  = aws_appautoscaling_target.neonlens[0].service_namespace
  scalable_dimension = aws_appautoscaling_target.neonlens[0].scalable_dimension
  resource_id        = aws_appautoscaling_target.neonlens[0].resource_id

  target_tracking_scaling_policy_configuration {
    target_value = var.cpu_target_value

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}


# ============================================================
# MEMORY TARGET TRACKING
# ============================================================

resource "aws_appautoscaling_policy" "neonlens_memory" {
  count = var.enable_autoscaling && var.enable_memory_autoscaling ? 1 : 0

  name = "${local.name_prefix}-memory-scaling"

  policy_type = "TargetTrackingScaling"

  service_namespace  = aws_appautoscaling_target.neonlens[0].service_namespace
  scalable_dimension = aws_appautoscaling_target.neonlens[0].scalable_dimension
  resource_id        = aws_appautoscaling_target.neonlens[0].resource_id

  target_tracking_scaling_policy_configuration {
    target_value = var.memory_target_value

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}