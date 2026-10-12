# ============================================================
# ALB
# ============================================================

output "alb_id" {
  description = "Application Load Balancer ID."
  value       = aws_lb.neonlens.id
}

output "alb_arn" {
  description = "Application Load Balancer ARN."
  value       = aws_lb.neonlens.arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name."
  value       = aws_lb.neonlens.dns_name
}

output "alb_zone_id" {
  description = "Application Load Balancer Route53 zone ID."
  value       = aws_lb.neonlens.zone_id
}


# ============================================================
# TARGET GROUP
# ============================================================

output "target_group_id" {
  description = "Target group ID."
  value       = aws_lb_target_group.neonlens.id
}

output "target_group_arn" {
  description = "Target group ARN."
  value       = aws_lb_target_group.neonlens.arn
}

output "target_group_name" {
  description = "Target group name."
  value       = aws_lb_target_group.neonlens.name
}


# ============================================================
# LISTENERS
# ============================================================

output "http_listener_arn" {
  description = "HTTP listener ARN."
  value       = try(aws_lb_listener.http[0].arn, null)
}

output "https_listener_arn" {
  description = "HTTPS listener ARN."
  value       = try(aws_lb_listener.https[0].arn, null)
}

# ============================================================
# GRAFANA TARGET GROUP
# ============================================================

output "grafana_target_group_id" {
  description = "Grafana target group ID."
  value       = aws_lb_target_group.grafana.id
}

output "grafana_target_group_arn" {
  description = "Grafana target group ARN for ECS service attachment."
  value       = aws_lb_target_group.grafana.arn
}

output "grafana_target_group_name" {
  description = "Grafana target group name."
  value       = aws_lb_target_group.grafana.name
}

output "grafana_listener_rule_arn" {
  description = "Grafana HTTPS listener rule ARN, if enabled."
  value       = try(aws_lb_listener_rule.grafana_host_header[0].arn, null)
}