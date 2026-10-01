locals {

  name_prefix = "${var.environment}-${var.name}"

  common_tags = merge(
    {
      Environment = "${var.environment}"
      Project     = "${var.name}"
      ManagedBy   = "Terraform"
      Component   = "ALB"
    },
    var.tags
  )

  load_balancer_name = "${local.name_prefix}-alb"

  target_group_name = "${local.name_prefix}-tg"



}