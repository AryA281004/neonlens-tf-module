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


# ============================================================
# PROJECT
# ============================================================

variable "name" {
  description = "Project name."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}


# ============================================================
# ROUTE 53 HOSTED ZONE
# ============================================================

variable "zone_id" {
  description = "Route 53 hosted zone ID."
  type        = string

  validation {
    condition     = length(trimspace(var.zone_id)) > 0
    error_message = "zone_id must not be empty."
  }
}


# ============================================================
# ROUTE 53 RECORDS
# ============================================================

variable "records" {
  description = "Map of Route 53 DNS records."

  type = map(object({
    name = string
    type = string

    ttl = optional(number)

    records = optional(list(string), [])

    set_identifier = optional(string)

    alias = optional(object({
      dns_name               = string
      zone_id                = string
      evaluate_target_health = bool
    }))
  }))

  validation {
    condition     = length(var.records) > 0
    error_message = "At least one Route 53 record must be defined."
  }
}


# ============================================================
# OPTIONS
# ============================================================

variable "allow_overwrite" {
  description = "Allow Terraform to overwrite existing Route 53 records."
  type        = bool
  default     = false
}


# ============================================================
# TAGS
# ============================================================

variable "tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}