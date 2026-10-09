# ============================================================
# PROMETHEUS CONFIGURATION BUCKET
# ============================================================

resource "aws_s3_bucket" "prometheus_config" {
  bucket_prefix = "${local.prometheus_name}"

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.prometheus_name}"
      Component = "Prometheus"
    }
  )
}


# ============================================================
# S3 ENCRYPTION
# ============================================================

resource "aws_s3_bucket_server_side_encryption_configuration" "prometheus_config" {
  bucket = aws_s3_bucket.prometheus_config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# ============================================================
# S3 PUBLIC ACCESS BLOCK
# ============================================================

resource "aws_s3_bucket_public_access_block" "prometheus_config" {
  bucket = aws_s3_bucket.prometheus_config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# ============================================================
# PROMETHEUS CONFIGURATION
# ============================================================

resource "aws_s3_object" "prometheus_config" {
  bucket = aws_s3_bucket.prometheus_config.id

  key = "prometheus/prometheus.yml"

  content = templatefile(
    "${path.module}/prometheus.yml",
    {
      environment = var.environment
    }
  )

  content_type = "text/yaml"

  server_side_encryption = "AES256"

  tags = local.common_tags
}


# ============================================================
# BACKEND RECORDING RULES
# ============================================================

resource "aws_s3_object" "backend_rules" {
  bucket = aws_s3_bucket.prometheus_config.id

  key = "prometheus/backend.rules.yml"

  content = file(
    "${path.module}/backend.rules.yml"
  )

  content_type = "text/yaml"

  server_side_encryption = "AES256"

  tags = local.common_tags
}


# ============================================================
# PROMETHEUS ALERT RULES
# ============================================================

resource "aws_s3_object" "alerts" {
  bucket = aws_s3_bucket.prometheus_config.id

  key = "prometheus/alerts.yml"

  content = file(
    "${path.module}/alerts.yml"
  )

  content_type = "text/yaml"

  server_side_encryption = "AES256"

  tags = local.common_tags
}


# ============================================================
# ECS TASK EXECUTION ROLE
# ============================================================

resource "aws_iam_role" "prometheus_execution" {
  name = "${local.prometheus_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}


# ============================================================
# ECS TASK EXECUTION POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "prometheus_execution" {
  role = aws_iam_role.prometheus_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ============================================================
# PROMETHEUS TASK ROLE
# ============================================================

resource "aws_iam_role" "prometheus_task" {
  name = "${local.prometheus_name}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}


# ============================================================
# PROMETHEUS TASK POLICY
# ============================================================

resource "aws_iam_role_policy" "prometheus_task" {
  name = "${local.prometheus_name}-task-policy"

  role = aws_iam_role.prometheus_task.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      # ------------------------------------------------------
      # PROMETHEUS CONFIGURATION
      # ------------------------------------------------------

      {
        Sid    = "ReadPrometheusConfiguration"
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = [
          aws_s3_object.prometheus_config.arn,
          aws_s3_object.backend_rules.arn,
          aws_s3_object.alerts.arn
        ]
      },

      # ------------------------------------------------------
      # EFS
      # ------------------------------------------------------

      {
        Sid    = "MountPrometheusEFS"
        Effect = "Allow"

        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite"
        ]

        Resource = aws_efs_file_system.prometheus.arn

        Condition = {
          StringEquals = {
            "elasticfilesystem:AccessPointArn" = aws_efs_access_point.prometheus.arn
          }
        }
      }
    ]
  })
}

# ============================================================
# GRAFANA ECS TASK EXECUTION ROLE
# ============================================================

resource "aws_iam_role" "grafana_execution" {
  name = "${local.grafana_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}


# ============================================================
# GRAFANA ECS TASK EXECUTION POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "grafana_execution" {
  role = aws_iam_role.grafana_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ============================================================
# GRAFANA TASK ROLE
# ============================================================

resource "aws_iam_role" "grafana_task" {
  name = "${local.grafana_name}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

# ============================================================
# GRAFANA TASK POLICY
# ============================================================

resource "aws_iam_role_policy" "grafana_task" {
  name = "${local.grafana_name}-task-policy"

  role = aws_iam_role.grafana_task.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      # ------------------------------------------------------
      # GRAFANA CONFIGURATION
      # ------------------------------------------------------

      {
        Sid    = "ReadGrafanaConfiguration"
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = [
          aws_s3_object.grafana_datasource.arn
        ]
      },

      # ------------------------------------------------------
      # GRAFANA EFS
      # ------------------------------------------------------

      {
        Sid    = "MountGrafanaEFS"
        Effect = "Allow"

        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite"
        ]

        Resource = aws_efs_file_system.grafana.arn

        Condition = {
          StringEquals = {
            "elasticfilesystem:AccessPointArn" = aws_efs_access_point.grafana.arn
          }
        }
      }
    ]
  })
}

# ============================================================
# GRAFANA DATASOURCE CONFIGURATION
# ============================================================

resource "aws_s3_object" "grafana_datasource" {
  bucket = aws_s3_bucket.prometheus_config.id

  key = "grafana/datasources/grafana.ini.yml"

  content = file(
    "${path.module}/grafana.ini.yml"
  )

  content_type = "text/yaml"

  server_side_encryption = "AES256"

  tags = merge(
    local.common_tags,
    {
      Component = "Grafana"
    }
  )
}