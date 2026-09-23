# ============================================================
# S3
# ============================================================

output "bucket_id" {
  description = "ID/name of the frontend S3 bucket."
  value       = aws_s3_bucket.neonlens.id
}

output "bucket_name" {
  description = "Name of the frontend S3 bucket."
  value       = aws_s3_bucket.neonlens.bucket
}

output "bucket_arn" {
  description = "ARN of the frontend S3 bucket."
  value       = aws_s3_bucket.neonlens.arn
}

output "bucket_regional_domain_name" {
  description = "Regional S3 domain name for CloudFront."
  value       = aws_s3_bucket.neonlens.bucket_regional_domain_name
}


# ============================================================
# CLOUDWATCH
# ============================================================

output "bucket_size_alarm_arn" {
  description = "ARN of the S3 bucket size CloudWatch alarm."
  value       = try("${aws_cloudwatch_metric_alarm.bucket_size[0].arn}", null)
}

output "bucket_size_alarm_name" {
  description = "Name of the S3 bucket size CloudWatch alarm."
  value       = try("${aws_cloudwatch_metric_alarm.bucket_size[0].alarm_name}", null)
}

output "object_count_alarm_arn" {
  description = "ARN of the S3 object count CloudWatch alarm."
  value       = try("${aws_cloudwatch_metric_alarm.object_count[0].arn}", null)
}

output "object_count_alarm_name" {
  description = "Name of the S3 object count CloudWatch alarm."
  value       = try("${aws_cloudwatch_metric_alarm.object_count[0].alarm_name}", null)
}


# ============================================================
# SNS
# ============================================================

output "sns_topic_arn" {
  description = "ARN of the S3 CloudWatch SNS topic."
  value       = try("${aws_sns_topic.s3_alerts[0].arn}", null)
}

output "sns_topic_name" {
  description = "Name of the S3 CloudWatch SNS topic."
  value       = try("${aws_sns_topic.s3_alerts[0].name}", null)
}


# ============================================================
# S3 BUCKET OUTPUTS
# ============================================================





output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.neonlens.arn
}

output "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.neonlens.bucket_regional_domain_name
}


# ============================================================
# CLOUDFRONT OUTPUTS
# ============================================================

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.neonlens.id
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.neonlens.arn
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.neonlens.domain_name
}

output "cloudfront_status" {
  description = "Current CloudFront distribution status"
  value       = aws_cloudfront_distribution.neonlens.status
}


# ============================================================
# CLOUDFRONT OAC OUTPUT
# ============================================================

output "cloudfront_origin_access_control_id" {
  description = "CloudFront Origin Access Control ID"
  value       = aws_cloudfront_origin_access_control.neonlens.id
}

output "cloudfront_origin_access_control_name" {
  description = "CloudFront Origin Access Control name"
  value       = aws_cloudfront_origin_access_control.neonlens.name
}


# ============================================================
# CLOUDFRONT URL
# ============================================================

output "cloudfront_url" {
  description = "CloudFront HTTPS URL"
  value       = "https://${aws_cloudfront_distribution.neonlens.domain_name}"
}