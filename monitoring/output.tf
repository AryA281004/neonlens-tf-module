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