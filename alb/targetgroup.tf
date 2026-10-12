# ============================================================
# TARGET GROUP
# ============================================================

resource "aws_lb_target_group" "neonlens" {
  name        = local.target_group_name
  port        = var.container_port
  protocol    = var.target_group_protocol
  target_type = "ip"

  vpc_id = var.vpc_id

  deregistration_delay = var.deregistration_delay

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    port                = "traffic-port"
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.target_group_name}"
      Component = "TargetGroup"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================
# GRAFANA TARGET GROUP
# ============================================================

resource "aws_lb_target_group" "grafana" {
  name        = local.grafana_target_group_name
  port        = var.grafana_port
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_id

  deregistration_delay = var.deregistration_delay

  health_check {
    enabled             = true
    path                = var.grafana_health_check_path
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200-399"
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = merge(local.common_tags, {
    Name      = local.grafana_target_group_name
    Component = "GrafanaTargetGroup"
  })

  lifecycle {
    create_before_destroy = true
  }
}