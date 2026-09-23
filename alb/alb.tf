# ============================================================
# APPLICATION LOAD BALANCER
# ============================================================

resource "aws_lb" "neonlens" {
  name               = local.load_balancer_name
  internal           = var.internal_load_balancer
  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.alb_subnet_ids

  enable_deletion_protection = var.enable_alb_deletion_protection

  drop_invalid_header_fields = true

  tags = merge(
    local.common_tags,
    {
      Name      = local.load_balancer_name
      Component = "LoadBalancer"
    }
  )
}