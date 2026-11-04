resource "aws_security_group" "mongodb" {
  name        = local.resource_names.security_group
  description = "MongoDB access restricted to the ${var.environment} ECS backend."
  vpc_id      = var.vpc_id

  ingress {
    description     = "MongoDB access from the environment's ECS backend only."
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [var.backend_security_group_id]
  }

  egress {
    description = "Outbound access for SSM, package installation, and AWS services."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = local.resource_names.security_group
  })
}