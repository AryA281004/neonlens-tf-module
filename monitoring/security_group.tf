resource "aws_security_group" "prometheus" {
  name        = "${local.prometheus_name}-sg"
  description = "Security group for NeonLens Prometheus."
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Grafana to query Prometheus."
    from_port       = var.prometheus_port
    to_port         = var.prometheus_port
    protocol        = "tcp"
    security_groups = [
      aws_security_group.grafana.id,
      var.alb_security_group_id
      ]
  }

  egress {
    description = "Allow outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name      = "${local.prometheus_name}-sg"
    Component = "Prometheus"
  })
}

resource "aws_security_group" "grafana" {
  name        = "${local.grafana_name}-sg"
  description = "Security group for NeonLens Grafana."
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow trusted ALB traffic to Grafana."
    from_port       = var.grafana_port
    to_port         = var.grafana_port
    protocol        = "tcp"
    security_groups = [var.grafana_alb_security_group_id]
  }

  egress {
    description = "Allow outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name      = "${local.grafana_name}-sg"
    Component = "Grafana"
  })
}