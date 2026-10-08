# ============================================================
# ECS SERVICE
# ============================================================

resource "aws_ecs_service" "neonlens" {
  name = local.service_name

  cluster = aws_ecs_cluster.neonlens.id

  task_definition = aws_ecs_task_definition.neonlens.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  platform_version = var.platform_version

  enable_execute_command = var.enable_execute_command

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  wait_for_steady_state = var.wait_for_steady_state

  deployment_circuit_breaker {
    enable   = var.enable_deployment_circuit_breaker
    rollback = var.enable_deployment_rollback
  }

  network_configuration {
    subnets = var.service_subnet_ids

    security_groups = [
      var.service_security_group_id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = var.container_port
  }

  dynamic "service_registries" {
    for_each = var.enable_service_discovery ? [1] : []

    content {
      registry_arn = aws_service_discovery_service.neonlens[0].arn
    }
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.execution,
    aws_iam_role_policy.execution_secrets
  ]

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.service_name}"
      Component = "Service"
    }
  )
}