# ============================================================
# VPC
# ============================================================

output "vpc_id" {
  description = "The ID of created VPC"
  value       = aws_vpc.neonlens.id
}


# ============================================================
# PUBLIC SUBNETS
# ============================================================

output "public_subnet_ids" {
  description = "Map of public subnet IDs keyed by subnet key"

  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
}


output "public_subnet_cidrs" {
  description = "Map of public subnet CIDR blocks keyed by subnet key"

  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.cidr_block
  }
}


# ============================================================
# PRIVATE SUBNETS
# ============================================================

output "private_subnet_ids" {
  description = "Map of private subnet IDs keyed by subnet key"

  value = {
    for key, subnet in aws_subnet.private :
    key => subnet.id
  }
}


output "private_subnet_cidrs" {
  description = "Map of private subnet CIDR blocks keyed by subnet key"

  value = {
    for key, subnet in aws_subnet.private :
    key => subnet.cidr_block
  }
}


# ============================================================
# SECURITY GROUPS
# ============================================================

output "security_group_ids" {
  description = "Map of security group IDs keyed by security group key"

  value = {
    for key, sg in aws_security_group.all_sg :
    key => sg.id
  }
}


output "default_security_group_id" {
  description = "ID of the locked-down default security group"

  value = aws_default_security_group.default.id
}


# ============================================================
# NAT GATEWAYS
# ============================================================

output "nat_gateway_ids" {
  description = "Map of NAT Gateway IDs keyed by public subnet key"

  value = {
    for key, nat in aws_nat_gateway.nat_gw :
    key => nat.id
  }
}


output "nat_gateway_eips" {
  description = "Map of NAT Gateway Elastic IP addresses keyed by public subnet key"

  value = {
    for key, eip in aws_eip.nat_eip :
    key => eip.public_ip
  }
}


# ============================================================
# ROUTE TABLES
# ============================================================

output "public_route_table_id" {
  description = "ID of the shared public route table"

  value = aws_route_table.public_rt.id
}


output "private_route_table_ids" {
  description = "Map of private route table IDs keyed by private subnet key"

  value = {
    for key, route_table in aws_route_table.private_rt :
    key => route_table.id
  }
}