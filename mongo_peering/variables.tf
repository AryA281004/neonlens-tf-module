variable "project_id" {
  description = "MongoDB Atlas project ID."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{24}$", var.project_id))
    error_message = "project_id must be a valid 24-character MongoDB Atlas project ID."
  }
}


variable "aws_account_id" {
  description = "AWS account ID that owns the application VPC."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must be a 12-digit AWS account ID."
  }
}


variable "aws_vpc_id" {
  description = "ID of the AWS application VPC."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.aws_vpc_id))
    error_message = "aws_vpc_id must be a valid AWS VPC ID."
  }
}


variable "aws_vpc_cidr" {
  description = "CIDR block of the AWS application VPC."
  type        = string
}


variable "aws_region" {
  description = "AWS region where the application VPC exists."
  type        = string
}


variable "atlas_region" {
  description = "MongoDB Atlas AWS region name, for example US_EAST_1."
  type        = string
}


variable "atlas_vpc_cidr" {
  description = "CIDR block of the existing MongoDB Atlas VPC."
  type        = string
}


variable "private_route_table_ids" {
  description = "Private AWS route tables that must route Atlas traffic through the peering connection."
  type        = list(string)

  validation {
    condition     = length(var.private_route_table_ids) > 0
    error_message = "At least one private route table ID must be provided."
  }
}


variable "environment" {
  description = "Environment name used for AWS resource naming and tags."
  type        = string
}


variable "tags" {
  description = "Additional tags for AWS resources."
  type        = map(string)
  default     = {}
}