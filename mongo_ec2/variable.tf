variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "pre", "prod"], var.environment)
    error_message = "Environment must be dev, pre, or prod."
  }
}

variable "project_name" {
  description = "Project name."
  type        = string
  default     = "neonlens"
}

variable "vpc_id" {
  description = "VPC in which MongoDB will run."
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet for the MongoDB instance."
  type        = string
}

variable "backend_security_group_id" {
  description = "ECS backend security group allowed to access MongoDB."
  type        = string
}

variable "instance_type" {
  description = "MongoDB EC2 instance type."
  type        = string
  default     = "t3.small"
}

variable "root_volume_size" {
  description = "EC2 root volume size in GiB."
  type        = number
  default     = 20
}

variable "database_volume_size" {
  description = "MongoDB data volume size in GiB."
  type        = number
  default     = 30
}

variable "database_name" {
  description = "Application database name."
  type        = string
  default     = "neonlens"
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}

variable "secret_arn" {
  description = "Existing AWS Secrets Manager ARN containing MongoDB credentials."
  type        = string
}