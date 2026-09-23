# ============================================================
# ALARM
# ============================================================

output "alarm_id" {
  description = "ID of the CloudWatch alarm."

  value = try(
    aws_cloudwatch_metric_alarm.alarm_5xx_neonlens[0].id,
    null
  )
}

output "alarm_arn" {
  description = "ARN of the CloudWatch alarm."

  value = try(
    aws_cloudwatch_metric_alarm.alarm_5xx_neonlens[0].arn,
    null
  )
}

output "alarm_name" {
  description = "Name of the CloudWatch alarm."

  value = try(
    aws_cloudwatch_metric_alarm.alarm_5xx_neonlens[0].alarm_name,
    null
  )
}