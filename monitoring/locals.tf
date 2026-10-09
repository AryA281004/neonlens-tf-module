locals {
  name_prefix = "${var.environment}-${var.name}-monitor"

  common_tags = merge(
    {
      Environment = var.environment
      Project     = var.name
      ManagedBy   = "Terraform"
      Component   = "Monitoring"
    },
    var.tags
  )

  prometheus_name = "${local.name_prefix}-prometheus"
  grafana_name    = "${local.name_prefix}-grafana"

  prometheus_container_name = "${local.prometheus_name}-container"
  grafana_container_name    = "${local.grafana_name}-container"

  prometheus_task_family = "${local.prometheus_name}-task"
  grafana_task_family    = "${local.grafana_name}-task"

  prometheus_service_name = "${local.prometheus_name}-service"
  grafana_service_name    = "${local.grafana_name}-service"
}