# ============================================================
# PROMETHEUS EFS
# ============================================================

resource "aws_efs_file_system" "prometheus" {
  creation_token = "${local.prometheus_name}-efs"

  encrypted = true

  performance_mode = "generalPurpose"

  throughput_mode = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.prometheus_name}-efs"
      Component = "Prometheus"
    }
  )
}


# ============================================================
# PROMETHEUS EFS ACCESS POINT
# ============================================================

resource "aws_efs_access_point" "prometheus" {
  file_system_id = aws_efs_file_system.prometheus.id

  posix_user {
    uid = 65534
    gid = 65534
  }

  root_directory {
    path = "/prometheus"

    creation_info {
      owner_gid   = 65534
      owner_uid   = 65534
      permissions = "0755"
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.prometheus_name}-access-point"
      Component = "Prometheus"
    }
  )
}


# ============================================================
# GRAFANA EFS
# ============================================================

resource "aws_efs_file_system" "grafana" {
  creation_token = "${local.grafana_name}-efs"

  encrypted = true

  performance_mode = "generalPurpose"

  throughput_mode = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.grafana_name}-efs"
      Component = "Grafana"
    }
  )
}


# ============================================================
# GRAFANA EFS ACCESS POINT
# ============================================================

resource "aws_efs_access_point" "grafana" {
  file_system_id = aws_efs_file_system.grafana.id

  posix_user {
    uid = 472
    gid = 472
  }

  root_directory {
    path = "/grafana"

    creation_info {
      owner_gid   = 472
      owner_uid   = 472
      permissions = "0755"
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.grafana_name}-access-point"
      Component = "Grafana"
    }
  )
}


# ============================================================
# EFS SECURITY GROUP
# ============================================================

resource "aws_security_group" "efs" {
  name        = "${local.name_prefix}-efs-sg"
  description = "Security group for NeonLens monitoring EFS."
  vpc_id      = var.vpc_id

  egress {
    description = "Allow outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.name_prefix}-efs-sg"
      Component = "EFS"
    }
  )
}


# ============================================================
# PROMETHEUS -> EFS
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "efs_from_prometheus" {
  security_group_id            = aws_security_group.efs.id
  referenced_security_group_id = aws_security_group.prometheus.id

  from_port   = 2049
  to_port     = 2049
  ip_protocol = "tcp"

  description = "Allow Prometheus ECS tasks to mount EFS."
}


# ============================================================
# GRAFANA -> EFS
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "efs_from_grafana" {
  security_group_id            = aws_security_group.efs.id
  referenced_security_group_id = aws_security_group.grafana.id

  from_port   = 2049
  to_port     = 2049
  ip_protocol = "tcp"

  description = "Allow Grafana ECS tasks to mount EFS."
}


# ============================================================
# PROMETHEUS EFS MOUNT TARGETS
# ============================================================

resource "aws_efs_mount_target" "prometheus" {
  for_each = toset(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.prometheus.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs.id]
}


# ============================================================
# GRAFANA EFS MOUNT TARGETS
# ============================================================

resource "aws_efs_mount_target" "grafana" {
  for_each = toset(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.grafana.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs.id]
}

