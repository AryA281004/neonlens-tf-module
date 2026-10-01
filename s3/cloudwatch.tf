# ============================================================
# SNS TOPIC
# ============================================================

resource "aws_sns_topic" "s3_alerts" {
  count = var.enable_sns_notifications ? 1 : 0

  name = "${var.environment}-${var.name}-s3-alerts"

  tags = merge(local.common_tags, {
    Component = "Monitoring"
  })
}


# ============================================================
# SNS EMAIL SUBSCRIPTION
# ============================================================

resource "aws_sns_topic_subscription" "email" {
  count = (
    var.enable_sns_notifications &&
    var.notification_email != null
  ) ? 1 : 0

  topic_arn = aws_sns_topic.s3_alerts[0].arn

  protocol = "email"
  endpoint = var.notification_email
}


# ============================================================
# CLOUDWATCH ALARM
# S3 BUCKET SIZE
# ============================================================

resource "aws_cloudwatch_metric_alarm" "bucket_size" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name = "${var.environment}-${var.name}-s3-bucket-size"

  alarm_description = "S3 bucket size exceeded the configured threshold."

  namespace   = "AWS/S3"
  metric_name = "BucketSizeBytes"

  dimensions = {
    BucketName  = aws_s3_bucket.neonlens.bucket
    StorageType = "StandardStorage"
  }

  statistic = "Average"

  period              = 86400
  evaluation_periods  = 1
  datapoints_to_alarm = 1

  threshold = var.bucket_size_alarm_threshold_gb * 1024 * 1024 * 1024

  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

  alarm_actions = var.enable_sns_notifications ? [
    aws_sns_topic.s3_alerts[0].arn
  ] : []

  tags = local.common_tags
}


# ============================================================
# CLOUDWATCH ALARM
# NUMBER OF OBJECTS
# ============================================================

resource "aws_cloudwatch_metric_alarm" "object_count" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name = "${var.environment}-${var.name}-s3-object-count"

  alarm_description = "S3 object count exceeded the configured threshold."

  namespace   = "AWS/S3"
  metric_name = "NumberOfObjects"

  dimensions = {
    BucketName  = aws_s3_bucket.neonlens.bucket
    StorageType = "AllStorageTypes"
  }

  statistic = "Average"

  period              = 86400
  evaluation_periods  = 1
  datapoints_to_alarm = 1

  threshold = var.object_count_alarm_threshold

  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

  alarm_actions = var.enable_sns_notifications ? [
    aws_sns_topic.s3_alerts[0].arn
  ] : []

  tags = local.common_tags
}