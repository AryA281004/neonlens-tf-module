output "peering_connection_id" {
  description = "AWS VPC peering connection ID."
  value       = aws_vpc_peering_connection_accepter.neonlens.id
}


output "atlas_peering_id" {
  description = "MongoDB Atlas peering connection ID."
  value       = mongodbatlas_network_peering.neonlens.id
}


output "atlas_container_id" {
  description = "MongoDB Atlas network peering container ID."
  value       = data.mongodbatlas_network_containers.aws[0].id
}


output "atlas_vpc_cidr" {
  description = "MongoDB Atlas VPC CIDR block."
  value       = var.atlas_vpc_cidr
}


output "aws_vpc_cidr" {
  description = "AWS application VPC CIDR block."
  value       = var.aws_vpc_cidr
}


output "private_route_table_ids" {
  description = "Private route tables configured for MongoDB Atlas."
  value       = var.private_route_table_ids
}


output "peering_status" {
  description = "MongoDB Atlas peering status."
  value       = mongodbatlas_network_peering.neonlens.status
}