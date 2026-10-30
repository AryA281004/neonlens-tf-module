# ============================================================
# MONGODB ATLAS NETWORK CONTAINER
# ============================================================

resource "mongodbatlas_network_container" "aws" {
  project_id       = var.project_id
  provider_name    = "AWS"
  atlas_cidr_block = var.atlas_vpc_cidr
  region_name      = local.atlas_region
}

# ============================================================
# MONGODB ATLAS → AWS VPC PEERING REQUEST
# ============================================================

resource "mongodbatlas_network_peering" "neonlens" {
  project_id = var.project_id

  container_id = mongodbatlas_network_container.aws.container_id

  provider_name = "AWS"

  accepter_region_name = var.aws_region

  aws_account_id = var.aws_account_id

  vpc_id = var.aws_vpc_id

  route_table_cidr_block = var.aws_vpc_cidr

  depends_on = [
    mongodbatlas_network_container.aws
  ]
}

# ============================================================
# AWS SIDE — ACCEPT THE PEERING CONNECTION
# ============================================================

resource "aws_vpc_peering_connection_accepter" "neonlens" {
  vpc_peering_connection_id = mongodbatlas_network_peering.neonlens.connection_id

  auto_accept = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-mongodb-atlas-peering"
    }
  )
}

# ============================================================
# AWS PRIVATE ROUTE TABLES → ATLAS VPC
# ============================================================

resource "aws_route" "atlas" {
  depends_on = [
    aws_vpc_peering_connection_accepter.neonlens
  ]

  count = length(var.private_route_table_ids)

  route_table_id = var.private_route_table_ids[count.index]

  destination_cidr_block = var.atlas_vpc_cidr

  vpc_peering_connection_id = (
    aws_vpc_peering_connection_accepter.neonlens.id
  )
}