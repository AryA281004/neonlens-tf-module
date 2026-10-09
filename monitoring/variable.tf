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
  description = "Application/project name."
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
  description = "VPC ID where monitoring resources are deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by Prometheus and Grafana."
  type        = map(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required for monitoring."
  }
}


# ============================================================
# EXISTING ECS CLUSTER
# ============================================================

variable "ecs_cluster_arn" {
  description = "ARN of the existing NeonLens ECS cluster."
  type        = string
}


# ============================================================
# EXISTING BACKEND
# ============================================================

variable "backend_service_name" {
  description = "Existing NeonLens backend ECS service name."
  type        = string
}

variable "container_port" {
  description = "NeonLens backend container port."
  type        = number

  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535
    error_message = "backend_container_port must be between 1 and 65535."
  }
}

variable "backend_security_group_id" {
  description = "Security group attached to the NeonLens backend ECS tasks."
  type        = string
}


# ============================================================
# PROMETHEUS
# ============================================================

variable "prometheus_image" {
  description = "Prometheus container image."
  type        = string
  default     = "prom/prometheus:v3.8.1"
}

variable "prometheus_port" {
  description = "Prometheus HTTP port."
  type        = number
  default     = 9090

  validation {
    condition     = var.prometheus_port >= 1 && var.prometheus_port <= 65535
    error_message = "prometheus_port must be between 1 and 65535."
  }
}

variable "prometheus_cpu" {
  description = "Prometheus task CPU units."
  type        = number
  default     = 1024
}

variable "prometheus_memory" {
  description = "Prometheus task memory in MiB."
  type        = number
  default     = 2048
}

variable "prometheus_desired_count" {
  description = "Number of Prometheus ECS tasks."
  type        = number
  default     = 1

  validation {
    condition     = var.prometheus_desired_count >= 1
    error_message = "prometheus_desired_count must be at least 1."
  }
}

variable "prometheus_retention" {
  description = "Prometheus TSDB retention period."
  type        = string
  default     = "15d"
}


# ============================================================
# GRAFANA
# ============================================================

variable "grafana_image" {
  description = "Grafana container image."
  type        = string
  default     = "grafana/grafana:12.2.0"
}

variable "grafana_port" {
  description = "Grafana HTTP port."
  type        = number
  default     = 3030

  validation {
    condition     = var.grafana_port >= 1 && var.grafana_port <= 65535
    error_message = "grafana_port must be between 1 and 65535."
  }
}

variable "grafana_cpu" {
  description = "Grafana task CPU units."
  type        = number
  default     = 512
}

variable "grafana_memory" {
  description = "Grafana task memory in MiB."
  type        = number
  default     = 1024
}

variable "grafana_desired_count" {
  description = "Number of Grafana ECS tasks."
  type        = number
  default     = 1

  validation {
    condition     = var.grafana_desired_count >= 1
    error_message = "grafana_desired_count must be at least 1."
  }
}


# ============================================================
# STORAGE
# ============================================================

variable "prometheus_efs_size_gib" {
  description = "Expected Prometheus EFS storage size in GiB."
  type        = number
  default     = 20
}

variable "grafana_efs_size_gib" {
  description = "Expected Grafana EFS storage size in GiB."
  type        = number
  default     = 5
}


# ============================================================
# LOGGING
# ============================================================

variable "log_retention_days" {
  description = "CloudWatch log retention period for monitoring containers."
  type        = number
  default     = 30
}

# ============================================================
# SERVICE DISCOVERY
# ============================================================

variable "service_discovery_namespace_id" {
  description = "Existing AWS Cloud Map private DNS namespace ID."
  type        = string
}

variable "prometheus_service_discovery_name" {
  description = "Cloud Map service name for Prometheus."
  type        = string
  default     = "prometheus"
}