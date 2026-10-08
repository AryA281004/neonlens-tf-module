# ============================================================
# MONITORING
# ============================================================

output "name_prefix" {
  description = "Monitoring resource name prefix."
  value       = local.name_prefix
}


# ============================================================
# PROMETHEUS
# ============================================================

output "prometheus_port" {
  description = "Prometheus HTTP port."
  value       = var.prometheus_port
}

output "prometheus_name" {
  description = "Prometheus resource name."
  value       = local.prometheus_name
}


# ============================================================
# GRAFANA
# ============================================================

output "grafana_port" {
  description = "Grafana HTTP port."
  value       = var.grafana_port
}

output "grafana_name" {
  description = "Grafana resource name."
  value       = local.grafana_name
}

# ============================================================
# GRAFANA
# ============================================================

output "grafana_port" {
  description = "Grafana HTTP port."
  value       = var.grafana_port
}

output "grafana_name" {
  description = "Grafana resource name."
  value       = local.grafana_name
}

output "grafana_service_name" {
  description = "Grafana ECS service name."
  value       = aws_ecs_service.grafana.name
}

output "grafana_security_group_id" {
  description = "Grafana security group ID."
  value       = aws_security_group.grafana.id
}