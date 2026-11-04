locals {
  name_prefix = "${var.project_name}-${var.environment}"

  resource_names = {
    security_group   = "${local.name_prefix}-mongodb-sg"
    iam_role         = "${local.name_prefix}-mongodb-role"
    iam_policy       = "${local.name_prefix}-mongodb-secret-access"
    instance_profile = "${local.name_prefix}-mongodb-profile"

    mongodb_instance = "${local.name_prefix}-mongodb"
    mongodb_volume   = "${local.name_prefix}-mongodb-data"
    mongodb_secret   = "${local.name_prefix}/mongodb/credentials"
  }



  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    Component   = "mongodb"
    ManagedBy   = "terraform"
  })
}