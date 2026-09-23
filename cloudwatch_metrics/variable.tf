variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)."
  type        = string
}

variable "name" {
  description = "Project name."
  type        = string
}





# ============================================================
# ENABLE / DISABLE
# ============================================================

variable "enabled" {
  description = "Whether to create the CloudWatch alarm."
  type        = bool
  default     = true
}


# ============================================================
# ALARM
# ============================================================


variable "alarm_description" {
  description = "Description of the CloudWatch alarm."
  type        = string
  default     = "This metric monitors 5xx count in target group"
}


# ============================================================
# METRIC
# ============================================================

variable "load_balancer_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the target group."
  type        = string
}


# ============================================================
# ALARM CONDITIONS
# ============================================================

variable "comparison_operator" {
  description = "CloudWatch alarm comparison operator."
  type        = string
  default     = "GreaterThanOrEqualToThreshold"
}

variable "evaluation_periods" {
  description = "Number of evaluation periods."
  type        = number
  default     = 1
}

variable "datapoints_to_alarm" {
  description = "Number of datapoints that must breach the threshold."
  type        = number
  default     = 1
}

variable "period" {
  description = "Period in seconds over which the metric is evaluated."
  type        = number
  default     = 60
}

variable "statistic" {
  description = "Statistic used to evaluate the metric."
  type        = string
  default     = "Sum"
}

variable "threshold" {
  description = "Threshold that triggers the alarm."
  type        = number
  default     = 4
}

variable "treat_missing_data" {
  description = "How CloudWatch handles missing data."
  type        = string
  default     = "notBreaching"
}


# ============================================================
# NOTIFICATIONS
# ============================================================

variable "alarm_actions" {
  description = "SNS topic ARNs or other alarm action ARNs."
  type        = list(string)
  default     = []
}


# ============================================================
# TAGS
# ============================================================

variable "tags" {
  description = "Tags applied to the CloudWatch alarm."
  type        = map(string)
  default     = {}
}

