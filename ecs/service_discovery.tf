# ============================================================
# AWS CLOUD MAP SERVICE DISCOVERY
# ============================================================

resource "aws_service_discovery_private_dns_namespace" "neonlens" {
  count = var.enable_service_discovery && var.service_discovery_namespace_id == null ? 1 : 0

  name = var.service_discovery_namespace_name
  vpc  = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name      = var.service_discovery_namespace_name
      Component = "ServiceDiscovery"
    }
  )
}

locals {
  service_discovery_namespace_id = var.service_discovery_namespace_id != null ? var.service_discovery_namespace_id : try(
    aws_service_discovery_private_dns_namespace.neonlens[0].id,
    null
  )
}

resource "aws_service_discovery_service" "neonlens" {
  count = var.enable_service_discovery ? 1 : 0

  name = var.service_discovery_service_name

  dns_config {
    namespace_id = local.service_discovery_namespace_id

    dns_records {
      ttl  = var.service_discovery_dns_ttl
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${var.service_discovery_service_name}.${var.service_discovery_namespace_name}"
      Component = "ServiceDiscovery"
    }
  )
}