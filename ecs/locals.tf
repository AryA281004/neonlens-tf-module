locals {
  name_prefix = "${var.environment}-${var.name}"

  common_tags = merge(
    {
      Environment = "${var.environment}"
      Project     = "${var.name}"
      ManagedBy   = "Terraform"
      Component   = "ECS"
    },
    var.tags
  )

  cluster_name        = "${local.name_prefix}-cluster"
  service_name        = "${local.name_prefix}-service"
  task_family         = "${local.name_prefix}-task"
  container_name      = "${local.name_prefix}-container"
  target_group_name   = "${local.name_prefix}-tg"
  load_balancer_name  = "${local.name_prefix}-alb"
  log_group_name      = "/ecs/${local.name_prefix}"

  execution_role_name = "${local.name_prefix}-execution-role"
  task_role_name      = "${local.name_prefix}-task-role"

  http_listener_name  = "${local.name_prefix}-http-listener"
  https_listener_name = "${local.name_prefix}-https-listener"

  container_health_check_command = coalesce(
  var.container_health_check_command,
  [
    "CMD-SHELL",
    "curl -f http://localhost:${var.container_port}/login || exit 1"
  ]
)

  container_environment = [
    for key, value in var.container_environment : {
      name  = key
      value = value
    }
  ]

  container_secrets = [
    for name, value_from in var.container_secrets : {
      name      = name
      valueFrom = value_from
    }
  ]
}