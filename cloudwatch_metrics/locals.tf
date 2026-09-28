locals {

  # ==========================================================
  # NAME
  # ==========================================================

  name_prefix = "${var.environment}-${var.name}"


  # ==========================================================
  # TAGS
  # ==========================================================

  common_tags = merge(
    {
      Environment = var.environment
      Project     = var.name
      ManagedBy   = "Terraform"
      Component   = "CloudWatch"
    },
    var.tags
  )
}