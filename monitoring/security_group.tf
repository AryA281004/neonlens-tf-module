# ============================================================
# PROMETHEUS SECURITY GROUP
# ============================================================

resource "aws_security_group" "prometheus" {
  name        = "${local.prometheus_name}-sg"
  description = "Security group for NeonLens Prometheus."
  vpc_id      = var.vpc_id

  egress {
    description = "Allow outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.prometheus_name}-sg"
      Component = "Prometheus"
    }
  )
}


# ============================================================
# GRAFANA SECURITY GROUP
# ============================================================

resource "aws_security_group" "grafana" {
  name        = "${local.grafana_name}-sg"
  description = "Security group for NeonLens Grafana."
  vpc_id      = var.vpc_id

  egress {
    description = "Allow outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.grafana_name}-sg"
      Component = "Grafana"
    }
  )
}


# ============================================================
# PROMETHEUS -> BACKEND
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "backend_from_prometheus" {
  security_group_id            = var.backend_security_group_id
  referenced_security_group_id = aws_security_group.prometheus.id

  from_port   = var.container_port
  to_port     = var.container_port
  ip_protocol = "tcp"

  description = "Allow Prometheus to scrape backend metrics."
}


# ============================================================
# PROMETHEUS -> GRAFANA
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "grafana_from_prometheus" {
  security_group_id            = aws_security_group.prometheus.id
  referenced_security_group_id = aws_security_group.grafana.id

  from_port   = var.prometheus_port
  to_port     = var.prometheus_port
  ip_protocol = "tcp"

  description = "Allow Prometheus traffic from Prometheus security group."
}