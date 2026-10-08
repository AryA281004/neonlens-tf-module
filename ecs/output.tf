# ============================================================
# ECS CLUSTER
# ============================================================

output "cluster_id" {
  description = "ECS cluster ID."
  value       = aws_ecs_cluster.neonlens.id
}

output "cluster_arn" {
  description = "ECS cluster ARN."
  value       = aws_ecs_cluster.neonlens.arn
}

output "cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.neonlens.name
}


# ============================================================
# ECS SERVICE
# ============================================================

output "service_id" {
  description = "ECS service ID."
  value       = aws_ecs_service.neonlens.id
}

output "service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.neonlens.name
}

output "service_arn" {
  description = "ECS service ARN."
  value       = aws_ecs_service.neonlens.arn
}


# ============================================================
# TASK DEFINITION
# ============================================================

output "task_definition_arn" {
  description = "ECS task definition ARN."
  value       = aws_ecs_task_definition.neonlens.arn
}

output "task_definition_family" {
  description = "ECS task definition family."
  value       = aws_ecs_task_definition.neonlens.family
}

output "task_definition_revision" {
  description = "Current ECS task definition revision."
  value       = aws_ecs_task_definition.neonlens.revision
}




# ============================================================
# CLOUDWATCH LOGS
# ============================================================

output "log_group_name" {
  description = "CloudWatch log group name."
  value       = aws_cloudwatch_log_group.neonlens.name
}

output "log_group_arn" {
  description = "CloudWatch log group ARN."
  value       = aws_cloudwatch_log_group.neonlens.arn
}


# ============================================================
# IAM
# ============================================================

output "execution_role_arn" {
  description = "ECS task execution role ARN."
  value       = aws_iam_role.execution.arn
}

output "task_role_arn" {
  description = "ECS task role ARN."
  value       = aws_iam_role.task.arn
}


# ============================================================
# AUTO SCALING
# ============================================================

output "autoscaling_target_arn" {
  description = "ECS Application Auto Scaling target ARN."
  value       = try(aws_appautoscaling_target.neonlens[0].arn, null)
}


# ============================================================
# ENDPOINT
# ============================================================

output "alb_url" {
  description = "HTTP endpoint for the Application Load Balancer."
  value       = "http://${var.alb_dns_name}"
}

output "https_url" {
  description = "HTTPS endpoint for the Application Load Balancer."
  value       = var.enable_https_listener ? "https://${var.alb_dns_name}" : null
}
# ============================================================
# CLOUD MAP SERVICE DISCOVERY
# ============================================================

output "service_discovery_namespace_id" {
  description = "AWS Cloud Map private DNS namespace ID."
  value       = var.enable_service_discovery ? local.service_discovery_namespace_id : null
}

output "service_discovery_namespace_name" {
  description = "AWS Cloud Map private DNS namespace name."
  value       = var.enable_service_discovery ? var.service_discovery_namespace_name : null
}

output "service_discovery_service_id" {
  description = "Cloud Map service ID."
  value       = try(aws_service_discovery_service.neonlens[0].id, null)
}

output "service_discovery_service_arn" {
  description = "Cloud Map service ARN."
  value       = try(aws_service_discovery_service.neonlens[0].arn, null)
}

output "service_discovery_dns_name" {
  description = "Private DNS name of the ECS service."
  value = var.enable_service_discovery ? format(
    "%s.%s",
    var.service_discovery_service_name,
    var.service_discovery_namespace_name
  ) : null
}