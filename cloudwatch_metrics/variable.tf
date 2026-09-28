# ============================================================
# BASIC
# ============================================================

variable "environment" {
  description = "Environment name."
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
  description = "Whether to create CloudWatch alarms."
  type        = bool
  default     = true
}


# ============================================================
# ALB DIMENSIONS
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
# ECS DIMENSIONS
# ============================================================

variable "ecs_cluster_name" {
  description = "ECS cluster name."
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name."
  type        = string
}


# ============================================================
# ALB ERROR THRESHOLDS
# ============================================================

variable "elb_4xx_threshold" {
  description = "Threshold for ALB-generated 4XX errors."
  type        = number
  default     = 5
}

variable "elb_5xx_threshold" {
  description = "Threshold for ALB-generated 5XX errors."
  type        = number
  default     = 5
}

variable "target_4xx_threshold" {
  description = "Threshold for target-generated 4XX errors."
  type        = number
  default     = 5
}

variable "target_5xx_threshold" {
  description = "Threshold for target-generated 5XX errors."
  type        = number
  default     = 5
}


# ============================================================
# ECS RESOURCE THRESHOLDS
# ============================================================

variable "cpu_threshold" {
  description = "CPU utilization percentage threshold."
  type        = number
  default     = 80
}

variable "memory_threshold" {
  description = "Memory utilization percentage threshold."
  type        = number
  default     = 80
}

variable "storage_threshold" {
  description = "Ephemeral storage utilization percentage threshold."
  type        = number
  default     = 80
}


# ============================================================
# ALARM EVALUATION
# ============================================================

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
  description = "Period in seconds."
  type        = number
  default     = 60
}


# ============================================================
# ALARM ACTION
# ============================================================

variable "alarm_actions" {
  description = "SNS topic ARNs or other alarm action ARNs."
  type        = list(string)
  default     = []
}

variable "treat_missing_data" {
  description = "How CloudWatch handles missing data."
  type        = string
  default     = "notBreaching"
}


# ============================================================
# TAGS
# ============================================================

variable "tags" {
  description = "Tags applied to CloudWatch alarms."
  type        = map(string)
  default     = {}
}