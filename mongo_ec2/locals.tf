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

  mongodb_secret_arns = {
    dev  = "arn:aws:secretsmanager:eu-west-1:666729139368:secret:neonlens/dev/mongodb/credentials-DF7agy"
    pre  = "arn:aws:secretsmanager:us-east-2:666729139368:secret:neonlens/pre/mongodb/credentials-jJBGB2"
    prod = "arn:aws:secretsmanager:us-east-1:666729139368:secret:neonlens/prod/mongodb/credentials-3mHU5C"
  }

mongodb_secret_arn = local.mongodb_secret_arns[terraform.workspace]

  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    Component   = "mongodb"
    ManagedBy   = "terraform"
  })
}