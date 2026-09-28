# ============================================================
# ALB 4XX
# ============================================================

resource "aws_cloudwatch_metric_alarm" "elb_4xx" {

  count = var.enabled ? 1 : 0

  alarm_name = "${local.name_prefix}-alb-4xx"

  alarm_description = "NeonLens ALB-generated 4XX errors."

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = var.evaluation_periods

  datapoints_to_alarm = var.datapoints_to_alarm

  namespace = "AWS/ApplicationELB"

  metric_name = "HTTPCode_ELB_4XX_Count"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
  }

  period = var.period

  statistic = "Sum"

  threshold = var.elb_4xx_threshold

  alarm_actions = var.alarm_actions

  insufficient_data_actions = []

  treat_missing_data = var.treat_missing_data

  tags = merge(
    local.common_tags,
    {
      Metric = "ALB-4XX"
    }
  )
}


# ============================================================
# ALB 5XX
# ============================================================

resource "aws_cloudwatch_metric_alarm" "elb_5xx" {

  count = var.enabled ? 1 : 0

  alarm_name = "${local.name_prefix}-alb-5xx"

  alarm_description = "NeonLens ALB-generated 5XX errors."

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = var.evaluation_periods

  datapoints_to_alarm = var.datapoints_to_alarm

  namespace = "AWS/ApplicationELB"

  metric_name = "HTTPCode_ELB_5XX_Count"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
  }

  period = var.period

  statistic = "Sum"

  threshold = var.elb_5xx_threshold

  alarm_actions = var.alarm_actions

  insufficient_data_actions = []

  treat_missing_data = var.treat_missing_data

  tags = merge(
    local.common_tags,
    {
      Metric = "ALB-5XX"
    }
  )
}


# ============================================================
# TARGET 4XX
# ============================================================

resource "aws_cloudwatch_metric_alarm" "target_4xx" {

  count = var.enabled ? 1 : 0

  alarm_name = "${local.name_prefix}-target-4xx"

  alarm_description = "NeonLens ECS target 4XX errors."

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = var.evaluation_periods

  datapoints_to_alarm = var.datapoints_to_alarm

  namespace = "AWS/ApplicationELB"

  metric_name = "HTTPCode_Target_4XX_Count"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  period = var.period

  statistic = "Sum"

  threshold = var.target_4xx_threshold

  alarm_actions = var.alarm_actions

  insufficient_data_actions = []

  treat_missing_data = var.treat_missing_data

  tags = merge(
    local.common_tags,
    {
      Metric = "TARGET-4XX"
    }
  )
}


# ============================================================
# TARGET 5XX
# ============================================================

resource "aws_cloudwatch_metric_alarm" "target_5xx" {

  count = var.enabled ? 1 : 0

  alarm_name = "${local.name_prefix}-target-5xx"

  alarm_description = "NeonLens ECS target 5XX errors."

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = var.evaluation_periods

  datapoints_to_alarm = var.datapoints_to_alarm

  namespace = "AWS/ApplicationELB"

  metric_name = "HTTPCode_Target_5XX_Count"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  period = var.period

  statistic = "Sum"

  threshold = var.target_5xx_threshold

  alarm_actions = var.alarm_actions

  insufficient_data_actions = []

  treat_missing_data = var.treat_missing_data

  tags = merge(
    local.common_tags,
    {
      Metric = "TARGET-5XX"
    }
  )
}


# ============================================================
# ECS CPU
# ============================================================

resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {

  count = var.enabled ? 1 : 0

  alarm_name = "${local.name_prefix}-ecs-cpu"

  alarm_description = "NeonLens ECS service CPU utilization is high."

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = var.evaluation_periods

  datapoints_to_alarm = var.datapoints_to_alarm

  namespace = "AWS/ECS"

  metric_name = "CPUUtilization"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  period = var.period

  statistic = "Average"

  threshold = var.cpu_threshold

  alarm_actions = var.alarm_actions

  insufficient_data_actions = []

  treat_missing_data = var.treat_missing_data

  tags = merge(
    local.common_tags,
    {
      Metric = "ECS-CPU"
    }
  )
}


# ============================================================
# ECS MEMORY
# ============================================================

resource "aws_cloudwatch_metric_alarm" "ecs_memory" {

  count = var.enabled ? 1 : 0

  alarm_name = "${local.name_prefix}-ecs-memory"

  alarm_description = "NeonLens ECS service memory utilization is high."

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = var.evaluation_periods

  datapoints_to_alarm = var.datapoints_to_alarm

  namespace = "AWS/ECS"

  metric_name = "MemoryUtilization"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  period = var.period

  statistic = "Average"

  threshold = var.memory_threshold

  alarm_actions = var.alarm_actions

  insufficient_data_actions = []

  treat_missing_data = var.treat_missing_data

  tags = merge(
    local.common_tags,
    {
      Metric = "ECS-MEMORY"
    }
  )
}


# ============================================================
# ECS EPHEMERAL STORAGE
# ============================================================

resource "aws_cloudwatch_metric_alarm" "ecs_storage" {

  count = var.enabled ? 1 : 0

  alarm_name = "${local.name_prefix}-ecs-storage"

  alarm_description = "NeonLens ECS ephemeral storage utilization is high."

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = var.evaluation_periods

  datapoints_to_alarm = var.datapoints_to_alarm

  namespace = "ECS/ContainerInsights"

  metric_name = "TaskEphemeralStorageUtilization"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  period = var.period

  statistic = "Average"

  threshold = var.storage_threshold

  alarm_actions = var.alarm_actions

  insufficient_data_actions = []

  treat_missing_data = var.treat_missing_data

  tags = merge(
    local.common_tags,
    {
      Metric = "ECS-EPHEMERAL-STORAGE"
    }
  )
}