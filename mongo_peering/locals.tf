locals {
  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "MongoDB Atlas Peering"
    },
    var.tags
  )


  atlas_region = upper(replace(var.atlas_region, "-", "_"))

  matching_atlas_containers = [
    for container in data.mongodbatlas_network_containers.aws.results :
    container
    if container.region_name == local.atlas_region &&
    container.atlas_cidr_block == var.atlas_vpc_cidr
  ]

  atlas_container_id = try(local.matching_atlas_containers.id, null)


}