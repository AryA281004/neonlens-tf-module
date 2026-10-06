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




}