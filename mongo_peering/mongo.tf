# ============================================================
# EXISTING ATLAS NETWORK CONTAINER
# ============================================================

data "mongodbatlas_network_containers" "aws" {
  project_id    = var.project_id
  provider_name = "AWS"
}





resource "terraform_data" "validate_atlas_container" {
  input = var.atlas_vpc_cidr

  lifecycle {
    precondition {
      condition     = length(local.matching_atlas_containers) == 1
      error_message = "No unique MongoDB Atlas network container was found for region ${local.atlas_region} with CIDR ${var.atlas_vpc_cidr}. The Atlas VPC/container must already exist."
    }
  }
}




# ============================================================
# MONGODB ATLAS → AWS VPC PEERING REQUEST
# ============================================================

resource "mongodbatlas_network_peering" "neonlens" {
  project_id = var.project_id

  container_id = data.mongodbatlas_network_containers.aws[0].id

  provider_name = "AWS"

  accepter_region_name = var.aws_region

  aws_account_id = var.aws_account_id

  vpc_id = var.aws_vpc_id

  /*
    This is the AWS VPC CIDR.

    Atlas needs this so it knows which AWS network
    is on the other side of the peering connection.
  */
  route_table_cidr_block = var.aws_vpc_cidr

  depends_on = [
    terraform_data.validate_atlas_container
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
    aws_vpc_peering_connection_accepter.neonlens,
    aws_route_table.private_rt
  ]

  for_each = toset(var.private_route_table_ids)

  route_table_id = each.value

  destination_cidr_block = var.atlas_vpc_cidr

  vpc_peering_connection_id = (
    aws_vpc_peering_connection_accepter.neonlens.id
  )

  
}