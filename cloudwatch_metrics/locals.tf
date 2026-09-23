

locals {

  # ----------------------------------------------------------
  # NAME
  # ----------------------------------------------------------

  name_prefix = "${var.environment}-${var.name}"

  alarm_name = "5xx-${local.name_prefix}"


  # ----------------------------------------------------------
  # TAGS
  # ----------------------------------------------------------

  common_tags = merge(
    {
      Environment = "${var.environment}"
      Project     = "${var.name}"
      ManagedBy   = "Terraform"
      Component   = "CloudWatch"
    },
    var.tags
  )
}