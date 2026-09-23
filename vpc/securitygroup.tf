resource "aws_security_group" "all_sg" {
  for_each = var.security_all_group

  name        = "${var.environment}-${var.vpc_name}-${each.key}-sg"
  description = each.value.description
  vpc_id      = aws_vpc.neonlens.id

  dynamic "ingress" {
    for_each = each.value.ingress
    iterator = rule

    content {
      description     = rule.value.description
      from_port       = rule.value.from_port
      to_port         = rule.value.to_port
      protocol        = rule.value.protocol
      cidr_blocks     = rule.value.cidr_blocks
      security_groups = rule.value.security_groups
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    iterator = rule

    content {
      description     = rule.value.description
      from_port       = rule.value.from_port
      to_port         = rule.value.to_port
      protocol        = rule.value.protocol
      cidr_blocks     = rule.value.cidr_blocks
      security_groups = rule.value.security_groups
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-${each.key}-sg"
  })
}
