# ============================================================
# ALB ERROR ALARMS
# ============================================================

output "elb_4xx_alarm_arn" {
  description = "ARN of the ALB 4XX CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.elb_4xx[0].arn, null)
}

output "elb_4xx_alarm_name" {
  description = "Name of the ALB 4XX CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.elb_4xx[0].alarm_name, null)
}


output "elb_5xx_alarm_arn" {
  description = "ARN of the ALB 5XX CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.elb_5xx[0].arn, null)
}

output "elb_5xx_alarm_name" {
  description = "Name of the ALB 5XX CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.elb_5xx[0].alarm_name, null)
}


# ============================================================
# TARGET ERROR ALARMS
# ============================================================

output "target_4xx_alarm_arn" {
  description = "ARN of the ECS target 4XX CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.target_4xx[0].arn, null)
}

output "target_4xx_alarm_name" {
  description = "Name of the ECS target 4XX CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.target_4xx[0].alarm_name, null)
}


output "target_5xx_alarm_arn" {
  description = "ARN of the ECS target 5XX CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.target_5xx[0].arn, null)
}

output "target_5xx_alarm_name" {
  description = "Name of the ECS target 5XX CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.target_5xx[0].alarm_name, null)
}


# ============================================================
# ECS CPU
# ============================================================

output "ecs_cpu_alarm_arn" {
  description = "ARN of the ECS CPU utilization CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.ecs_cpu[0].arn, null)
}

output "ecs_cpu_alarm_name" {
  description = "Name of the ECS CPU utilization CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.ecs_cpu[0].alarm_name, null)
}


# ============================================================
# ECS MEMORY
# ============================================================

output "ecs_memory_alarm_arn" {
  description = "ARN of the ECS memory utilization CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.ecs_memory[0].arn, null)
}

output "ecs_memory_alarm_name" {
  description = "Name of the ECS memory utilization CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.ecs_memory[0].alarm_name, null)
}


# ============================================================
# ECS STORAGE
# ============================================================

output "ecs_storage_alarm_arn" {
  description = "ARN of the ECS ephemeral storage utilization CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.ecs_storage[0].arn, null)
}

output "ecs_storage_alarm_name" {
  description = "Name of the ECS ephemeral storage utilization CloudWatch alarm."
  value       = try(aws_cloudwatch_metric_alarm.ecs_storage[0].alarm_name, null)
}


# ============================================================
# ALL ALARM ARNS
# ============================================================

output "alarm_arns" {
  description = "Map of all NeonLens CloudWatch alarm ARNs."
  value = {
    elb_4xx    = try(aws_cloudwatch_metric_alarm.elb_4xx[0].arn, null)
    elb_5xx    = try(aws_cloudwatch_metric_alarm.elb_5xx[0].arn, null)
    target_4xx = try(aws_cloudwatch_metric_alarm.target_4xx[0].arn, null)
    target_5xx = try(aws_cloudwatch_metric_alarm.target_5xx[0].arn, null)
    ecs_cpu    = try(aws_cloudwatch_metric_alarm.ecs_cpu[0].arn, null)
    ecs_memory = try(aws_cloudwatch_metric_alarm.ecs_memory[0].arn, null)
    ecs_storage = try(
      aws_cloudwatch_metric_alarm.ecs_storage[0].arn,
      null
    )
  }
}


# ============================================================
# ALL ALARM NAMES
# ============================================================

output "alarm_names" {
  description = "Map of all NeonLens CloudWatch alarm names."
  value = {
    elb_4xx    = try(aws_cloudwatch_metric_alarm.elb_4xx[0].alarm_name, null)
    elb_5xx    = try(aws_cloudwatch_metric_alarm.elb_5xx[0].alarm_name, null)
    target_4xx = try(aws_cloudwatch_metric_alarm.target_4xx[0].alarm_name, null)
    target_5xx = try(aws_cloudwatch_metric_alarm.target_5xx[0].alarm_name, null)
    ecs_cpu    = try(aws_cloudwatch_metric_alarm.ecs_cpu[0].alarm_name, null)
    ecs_memory = try(aws_cloudwatch_metric_alarm.ecs_memory[0].alarm_name, null)
    ecs_storage = try(
      aws_cloudwatch_metric_alarm.ecs_storage[0].alarm_name,
      null
    )
  }
}