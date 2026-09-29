
variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)."
  type        = string
}

variable "name" {
  description = "Project name."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
}

variable "alb_subnet_ids" {
  description = "Public subnet IDs for the Application Load Balancer."
  type        = list(string)

  validation {
    condition     = length(var.alb_subnet_ids) >= 2
    error_message = "At least two ALB subnets are required for high availability."
  }
}

variable "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer."
  type        = string
}

variable "service_security_group_id" {
  description = "Security group ID for ECS tasks."
  type        = string
}


variable "internal_load_balancer" {
  description = "Whether the ALB is internal."
  type        = bool
  default     = false
}

variable "enable_alb_deletion_protection" {
  description = "Enable deletion protection on the ALB."
  type        = bool
  default     = true
}

variable "enable_http_listener" {
  description = "Create an HTTP listener."
  type        = bool
  default     = true
}

variable "enable_https_listener" {
  description = "Create an HTTPS listener."
  type        = bool
  default     = true
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener."
  type        = string
  default     = null
}

variable "alb_ssl_policy" {
  description = "TLS security policy for the HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
}


variable "container_port" {
  description = "Port exposed by the application container."
  type        = number
  default     = 3000

  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535
    error_message = "container_port must be between 1 and 65535."
  }
}

variable "target_group_protocol" {
  description = "Protocol used by the ALB target group."
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.target_group_protocol)
    error_message = "target_group_protocol must be HTTP or HTTPS."
  }
}

variable "health_check_path" {
  description = "ALB health check path."
  type        = string
  default     = "/health"
}

variable "health_check_protocol" {
  description = "ALB health check protocol."
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.health_check_protocol)
    error_message = "health_check_protocol must be HTTP or HTTPS."
  }
}

variable "health_check_matcher" {
  description = "Expected ALB health check response codes."
  type        = string
  default     = "200-399"
}

variable "health_check_interval" {
  description = "ALB health check interval in seconds."
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "ALB health check timeout in seconds."
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of successful checks before healthy."
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of failed checks before unhealthy."
  type        = number
  default     = 3
}

variable "deregistration_delay" {
  description = "ALB target deregistration delay."
  type        = number
  default     = 30
}
