# ============================================================
# ENVIRONMENT
# ============================================================

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string

  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must not be empty."
  }
}


# ============================================================
# VPC
# ============================================================

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}


variable "vpc_name" {
  description = "Name of the VPC"
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_name)) > 0
    error_message = "vpc_name must not be empty."
  }
}


# ============================================================
# PUBLIC SUBNETS
# ============================================================
# One NAT Gateway is created per public subnet defined here, so
# every key you add becomes a valid `nat_gateway_key` target for a
# private subnet below (this is what gives you per-AZ NAT).

variable "public_subnet_cidr" {
  description = "Map of public subnet CIDRs and Availability Zones"

  type = map(object({
    cidr_block = string
    az         = string
  }))

  validation {
    condition     = length(var.public_subnet_cidr) > 0
    error_message = "At least one public subnet must be defined."
  }
}


# ============================================================
# PRIVATE SUBNETS
# ============================================================

variable "private_subnet_cidr" {
  description = "Map of private subnet CIDRs, Availability Zones, and which public-subnet's NAT Gateway they route through"

  type = map(object({
    cidr_block      = string
    az              = string
    nat_gateway_key = string # must match a key in var.public_subnet_cidr
  }))

  validation {
    condition     = length(var.private_subnet_cidr) > 0
    error_message = "At least one private subnet must be defined."
  }

  validation {
    condition = alltrue([
      for s in var.private_subnet_cidr : contains(keys(var.public_subnet_cidr), s.nat_gateway_key)
    ])
    error_message = "Every private subnet's nat_gateway_key must match a key defined in var.public_subnet_cidr."
  }
}

variable "nat_gateway_subnet_key" {
  description = "Key of the public subnet to place the NAT Gateway in (must match a key in var.public_subnet_cidr)"
  type        = string

  validation {
    condition     = contains(keys(var.public_subnet_cidr), var.nat_gateway_subnet_key)
    error_message = "nat_gateway_subnet_key must match a key defined in var.public_subnet_cidr."
  }
}

# ============================================================
# SECURITY GROUPS
# ============================================================

variable "security_all_group" {
  description = "Map of security group configurations"

  type = map(object({
    description = string

    ingress = list(object({
      description     = optional(string, "")
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string), [])
      security_groups = optional(list(string), [])
    }))

    egress = list(object({
      description     = optional(string, "")
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string), [])
      security_groups = optional(list(string), [])
    }))
  }))
}
