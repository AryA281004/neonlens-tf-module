# ============================================================
# GENERAL
# ============================================================

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "environment must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "name" {
  description = "Application/service name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}


variable "tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}


# ============================================================
# NETWORK
# ============================================================

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}



variable "service_subnet_ids" {
  description = "Private subnet IDs for ECS tasks."
  type        = list(string)

  validation {
    condition     = length(var.service_subnet_ids) >= 2
    error_message = "At least two ECS service subnets are required for high availability."
  }
}



variable "service_security_group_id" {
  description = "Security group ID for ECS tasks."
  type        = string
}


# ============================================================
# LOAD BALANCER
# ============================================================

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






# ============================================================
# TARGET GROUP / HEALTH CHECK
# ============================================================

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number


  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535
    error_message = "container_port must be between 1 and 65535."
  }
}


# ============================================================
# CONTAINER
# ============================================================

variable "container_image" {
  description = "Full container image URI."
  type        = string
}

variable "container_cpu" {
  description = "CPU units assigned to the container."
  type        = number
  default     = 512
}

variable "container_memory" {
  description = "Memory in MiB assigned to the container."
  type        = number
  default     = 1024
}

variable "task_cpu" {
  description = "Total task CPU units."
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Total task memory in MiB."
  type        = number
  default     = 1024
}

variable "container_environment" {
  description = "Environment variables passed to the container."
  type        = map(string)
  default     = {}
}

variable "container_secrets" {
  description = "Map of environment variable names to Secrets Manager valueFrom ARNs."
  type        = map(string)
  default     = {}
}

variable "execution_secret_arns" {
  description = "Secrets Manager ARNs that the ECS execution role can read."
  type        = list(string)
  default     = []
}


# ============================================================
# CONTAINER HEALTH
# ============================================================

variable "enable_container_health_check" {
  description = "Enable ECS container health check."
  type        = bool
  default     = true
}

variable "container_health_check_command" {
  description = "ECS container health check command. If null, a health check using container_port is generated."
  type        = list(string)
  default     = null
}

variable "container_health_check_interval" {
  description = "Container health check interval."
  type        = number
  default     = 30
}

variable "container_health_check_timeout" {
  description = "Container health check timeout."
  type        = number
  default     = 5
}

variable "container_health_check_retries" {
  description = "Number of container health check retries."
  type        = number
  default     = 3
}

variable "container_health_check_start_period" {
  description = "Container health check start period."
  type        = number
  default     = 60
}


# ============================================================
# CONTAINER RUNTIME
# ============================================================

variable "readonly_root_filesystem" {
  description = "Make the container root filesystem read-only."
  type        = bool
  default     = false
}

variable "container_stop_timeout" {
  description = "Seconds ECS waits before forcefully stopping the container."
  type        = number
  default     = 30
}

variable "cpu_architecture" {
  description = "CPU architecture."
  type        = string
  default     = "X86_64"

  validation {
    condition     = contains(["X86_64", "ARM64"], var.cpu_architecture)
    error_message = "cpu_architecture must be X86_64 or ARM64."
  }
}

variable "operating_system_family" {
  description = "Operating system family."
  type        = string
  default     = "LINUX"
}

variable "ephemeral_storage_gib" {
  description = "Optional Fargate ephemeral storage size in GiB."
  type        = number
  default     = null

  validation {
    condition     = var.ephemeral_storage_gib == null || try(var.ephemeral_storage_gib >= 21 && var.ephemeral_storage_gib <= 200, false)
    error_message = "ephemeral_storage_gib must be between 21 and 200 GiB."
  }
}


# ============================================================
# ECS SERVICE
# ============================================================

variable "desired_count" {
  description = "Initial desired number of ECS tasks."
  type        = number
  default     = 2

  validation {
    condition     = var.desired_count >= 1
    error_message = "desired_count must be at least 1."
  }
}

variable "platform_version" {
  description = "Fargate platform version."
  type        = string
  default     = "LATEST"
}

variable "health_check_grace_period_seconds" {
  description = "Grace period before ECS evaluates load balancer health."
  type        = number
  default     = 60
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy percentage during deployment."
  type        = number
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "Maximum percentage of desired tasks during deployment."
  type        = number
  default     = 200
}

variable "wait_for_steady_state" {
  description = "Wait for ECS service to reach a steady state."
  type        = bool
  default     = true
}

variable "enable_deployment_circuit_breaker" {
  description = "Enable ECS deployment circuit breaker."
  type        = bool
  default     = true
}

variable "enable_deployment_rollback" {
  description = "Automatically roll back failed ECS deployments."
  type        = bool
  default     = true
}


# ============================================================
# ECS EXEC
# ============================================================

variable "enable_execute_command" {
  description = "Enable ECS Exec."
  type        = bool
  default     = false
}


# ============================================================
# CLOUDWATCH
# ============================================================

variable "log_retention_days" {
  description = "CloudWatch log retention period."
  type        = number
  default     = 30
}

variable "log_stream_prefix" {
  description = "CloudWatch log stream prefix."
  type        = string
  default     = "ecs"
}

variable "enable_container_insights" {
  description = "Enable ECS Container Insights."
  type        = bool
  default     = true
}


# ============================================================
# TASK ROLE
# ============================================================

variable "task_role_policy_arns" {
  description = "IAM managed policy ARNs attached to the ECS task role."
  type        = list(string)
  default     = []
}


# ============================================================
# AUTO SCALING
# ============================================================

variable "enable_autoscaling" {
  description = "Enable ECS service auto scaling."
  type        = bool
  default     = true
}

variable "autoscaling_min_capacity" {
  description = "Minimum ECS task count."
  type        = number
  default     = 2
}

variable "autoscaling_max_capacity" {
  description = "Maximum ECS task count."
  type        = number
  default     = 6
}

variable "enable_cpu_autoscaling" {
  description = "Enable CPU target tracking."
  type        = bool
  default     = true
}

variable "enable_memory_autoscaling" {
  description = "Enable memory target tracking."
  type        = bool
  default     = true
}

variable "cpu_target_value" {
  description = "Target average CPU utilization percentage."
  type        = number
  default     = 60
}

variable "memory_target_value" {
  description = "Target average memory utilization percentage."
  type        = number
  default     = 70
}

variable "scale_in_cooldown" {
  description = "Scale-in cooldown in seconds."
  type        = number
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Scale-out cooldown in seconds."
  type        = number
  default     = 60
}

variable "target_group_arn" {
  description = "ARN of the ALB target group."
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB, passed in from the alb module."
  type        = string
}