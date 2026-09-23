# ============================================================
# VPC
# ============================================================

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.neonlens.id
}


# ============================================================
# PUBLIC SUBNETS
# ============================================================

output "public_subnet_ids" {
  description = "Map of public subnet IDs"
  value = {
    for key, subnet in aws_subnet.public : key => subnet.id
  }
}


output "public_subnet_cidrs" {
  description = "Map of public subnet CIDR blocks"
  value = {
    for key, subnet in aws_subnet.public : key => subnet.cidr_block
  }
}


# ============================================================
# PRIVATE SUBNETS
# ============================================================

output "private_subnet_ids" {
  description = "Map of private subnet IDs"
  value = {
    for key, subnet in aws_subnet.private : key => subnet.id
  }
}


output "private_subnet_cidrs" {
  description = "Map of private subnet CIDR blocks"
  value = {
    for key, subnet in aws_subnet.private : key => subnet.cidr_block
  }
}


# ============================================================
# SECURITY GROUPS
# ============================================================

output "security_group_ids" {
  description = "Map of security group IDs"
  value = {
    for key, sg in aws_security_group.all_sg : key => sg.id
  }
}


output "default_security_group_id" {
  description = "ID of the locked-down default security group"
  value       = aws_default_security_group.default.id
}


# ============================================================
# NAT GATEWAYS
# ============================================================
output "nat_gateway_id" {
  description = "ID of the NAT Gateway."

  value = aws_nat_gateway.nat_gw.id
}


output "nat_gateway_eips" {
  description = "Map of NAT Gateway Elastic IPs, keyed by public subnet key"
  value = aws_eip.nat_eip.id
}


# ============================================================
# ROUTE TABLES
# ============================================================

output "public_route_table_id" {
  description = "ID of the shared public route table"
  value       = aws_route_table.public_rt.id
}


output "private_route_table_ids" {
  description = "Map of private route table IDs, keyed by private subnet key (one per AZ)"
  value = aws_route_table.private_rt.id
}
