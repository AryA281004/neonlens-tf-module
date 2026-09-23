




# ============================================================
# HTTP LISTENER
# ============================================================

resource "aws_lb_listener" "http" {
  count = var.enable_http_listener ? 1 : 0

  load_balancer_arn = aws_lb.neonlens.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.enable_https_listener ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.enable_https_listener ? [1] : []

      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    dynamic "forward" {
      for_each = var.enable_https_listener ? [] : [1]

      content {
        target_group {
          arn = aws_lb_target_group.neonlens.arn
        }
      }
    }
  }

  tags = local.common_tags
}


# ============================================================
# HTTPS LISTENER
# ============================================================

resource "aws_lb_listener" "https" {
  count = var.enable_https_listener ? 1 : 0

  load_balancer_arn = aws_lb.neonlens.arn

  port     = 443
  protocol = "HTTPS"

  ssl_policy = var.alb_ssl_policy

  certificate_arn = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.neonlens.arn
  }

  tags = local.common_tags
}