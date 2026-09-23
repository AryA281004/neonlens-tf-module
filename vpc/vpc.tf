# ============================================================
# COMMON TAGS
# ============================================================

locals {
  common_tags = {
    Environment = "${var.environment}"
    Project     = "${var.vpc_name}"
    ManagedBy   = "Terraform"
  }
}


# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "neonlens" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-vpc"
  })
}


# ============================================================
# DEFAULT SECURITY GROUP (locked down — CIS AWS benchmark)
# ============================================================


resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.neonlens.id

  ingress = []
  egress  = []

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-default-sg-locked"
  })
}


# ============================================================
# PUBLIC SUBNETS
# ============================================================

resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidr

  vpc_id                  = aws_vpc.neonlens.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-${each.key}-public-subnet"
    Type = "public"
  })
}


# ============================================================
# PRIVATE SUBNETS
# ============================================================

resource "aws_subnet" "private" {
  for_each = var.private_subnet_cidr

  vpc_id            = aws_vpc.neonlens.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-${each.key}-private-subnet"
    Type = "private"
  })
}


# ============================================================
# PUBLIC ROUTE TABLE
# ============================================================

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.neonlens.id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-public-rt"
  })
}


# ============================================================
# PUBLIC SUBNET ASSOCIATIONS
# ============================================================

resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}


# ============================================================
# INTERNET GATEWAY
# ============================================================

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.neonlens.id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-igw"
  })
}


# ============================================================
# PUBLIC ROUTE → INTERNET GATEWAY
# ============================================================

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.public_igw.id
}


# ============================================================
# NAT GATEWAY EIPs — one per public subnet (per AZ)
# ============================================================

# ============================================================
# NAT GATEWAY EIP
# ============================================================

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-nat-eip"
  })
}


# ============================================================
# NAT GATEWAYS — one per public subnet (per AZ)
# ============================================================

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public[
    var.nat_gateway_subnet_key
  ].id

  depends_on = [aws_internet_gateway.public_igw]

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-nat-gw"
  })
}



# ============================================================
# PRIVATE ROUTE TABLE
# ============================================================

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.neonlens.id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.vpc_name}-private-rt"
  })
}


# ============================================================
# PRIVATE ROUTE → NAT GATEWAY
# ============================================================

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}


# ============================================================
# PRIVATE SUBNET ASSOCIATIONS
# ============================================================

resource "aws_route_table_association" "private_rt_assoc" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}