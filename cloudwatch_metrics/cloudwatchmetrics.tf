# ============================================================
# 5XX ALARM
# ============================================================

resource "aws_cloudwatch_metric_alarm" "alarm_5xx_neonlens" {

  count = var.enabled ? 1 : 0

  alarm_name = local.alarm_name

  alarm_description = var.alarm_description

  comparison_operator = var.comparison_operator

  evaluation_periods = var.evaluation_periods

  datapoints_to_alarm = var.datapoints_to_alarm

  namespace = "AWS/ApplicationELB"

  metric_name = "HTTPCode_Target_5XX_Count"

  dimensions = {
    LoadBalancer = "${aws_lb.neonlens.arn_suffix}"
    TargetGroup  = "${aws_lb_target_group.neonlens.arn_suffix}"
  }

  period = var.period

  statistic = var.statistic

  threshold = var.threshold

  alarm_actions = var.alarm_actions

  insufficient_data_actions = []

  treat_missing_data = var.treat_missing_data

  tags = local.common_tags

  lifecycle {
    ignore_changes = [
      threshold
    ]
  }
}