# ============================================================
# ENVIRONMENT
# ============================================================

variable "environment" {
  description = "Environment name, for example dev, staging, or prod."
  type        = string

  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must not be empty."
  }
}


variable "name" {
  description = "Project name."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}


# ============================================================
# DOMAIN
# ============================================================

variable "domain_name" {
  description = "Route 53 hosted zone domain name."
  type        = string

  validation {
    condition     = length(trimspace(var.domain_name)) > 0
    error_message = "domain_name must not be empty."
  }
}


# ============================================================
# RECORD
# ============================================================

variable "record_name" {
  description = "DNS record name. Use the root domain itself for an apex record."
  type        = string

  validation {
    condition     = length(trimspace(var.record_name)) > 0
    error_message = "record_name must not be empty."
  }
}


# ============================================================
# ALB
# ============================================================

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  type        = string

  validation {
    condition     = length(trimspace(var.alb_dns_name)) > 0
    error_message = "alb_dns_name must not be empty."
  }
}

variable "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer."
  type        = string

  validation {
    condition     = length(trimspace(var.alb_zone_id)) > 0
    error_message = "alb_zone_id must not be empty."
  }
}


# ============================================================
# ROUTING
# ============================================================

variable "evaluate_target_health" {
  description = "Whether Route 53 should evaluate the health of the ALB target."
  type        = bool
  default     = true
}


# ============================================================
# TAGS
# ============================================================

variable "tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}

variable "zone_id" {
  description = "Route 53 hosted zone ID."
  type        = string

  validation {
    condition     = length(trimspace(var.zone_id)) > 0
    error_message = "zone_id must not be empty."
  }
}


variable "records" {
  description = "Map of Route 53 DNS records."

  type = map(object({
    name = string
    type = string

    ttl = optional(number)

    records = optional(list(string), [])

    set_identifier = optional(string)

    alias = optional(object({
      dns_name                = string
      zone_id                 = string
      evaluate_target_health  = bool
    }))
  }))

  validation {
    condition     = length(var.records) > 0
    error_message = "At least one Route 53 record must be defined."
  }
}


variable "allow_overwrite" {
  description = "Allow Terraform to overwrite existing Route 53 records."
  type        = bool
  default     = false
}