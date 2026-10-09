# ============================================================
# PROMETHEUS CLOUDWATCH LOG GROUP
# ============================================================

resource "aws_cloudwatch_log_group" "prometheus" {
  name              = "/ecs/${local.prometheus_name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    local.common_tags,
    {
      Name      = "/ecs/${local.prometheus_name}"
      Component = "Prometheus"
    }
  )
}


# ============================================================
# PROMETHEUS ECS TASK DEFINITION
# ============================================================

resource "aws_ecs_task_definition" "prometheus" {
  family = local.prometheus_task_family

  cpu    = var.prometheus_cpu
  memory = var.prometheus_memory

  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  execution_role_arn = aws_iam_role.prometheus_execution.arn

  task_role_arn = aws_iam_role.prometheus_task.arn

  # ----------------------------------------------------------
  # PROMETHEUS DATA
  # ----------------------------------------------------------

  volume {
    name = "prometheus-data"

    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.prometheus.id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.prometheus.id
        iam             = "ENABLED"
      }
    }
  }

  # ----------------------------------------------------------
  # SHARED CONFIGURATION VOLUME
  # ----------------------------------------------------------

  volume {
    name = "prometheus-config"
  }

  # ----------------------------------------------------------
  # CONTAINERS
  # ----------------------------------------------------------

  container_definitions = jsonencode(
    [

      # ======================================================
      # CONFIG INIT CONTAINER
      # ======================================================

      {
        name = "config-init"

        image = "public.ecr.aws/aws-cli/aws-cli:2"

        essential = false

        command = [
          "s3",
          "cp",
          "s3://${aws_s3_bucket.prometheus_config.id}/prometheus/",
          "/config/",
          "--recursive"
        ]

        mountPoints = [
          {
            sourceVolume  = "prometheus-config"
            containerPath = "/config"
            readOnly      = false
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"

          options = {
            awslogs-group         = aws_cloudwatch_log_group.prometheus.name
            awslogs-region        = var.aws_region
            awslogs-stream-prefix = "config"
          }
        }
      },


      # ======================================================
      # PROMETHEUS
      # ======================================================

      {
        name = local.prometheus_container_name

        image = var.prometheus_image

        essential = true

        command = [
          "--config.file=/etc/prometheus/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--storage.tsdb.retention.time=${var.prometheus_retention}",
          "--web.listen-address=0.0.0.0:${var.prometheus_port}"
        ]

        portMappings = [
          {
            containerPort = var.prometheus_port
            hostPort      = var.prometheus_port
            protocol      = "tcp"
          }
        ]

        mountPoints = [
          {
            sourceVolume  = "prometheus-data"
            containerPath = "/prometheus"
            readOnly      = false
          },
          {
            sourceVolume  = "prometheus-config"
            containerPath = "/etc/prometheus"
            readOnly      = true
          }
        ]

        dependsOn = [
          {
            containerName = "config-init"
            condition     = "SUCCESS"
          }
        ]

        healthCheck = {
          command = [
            "CMD-SHELL",
            "wget --no-verbose --tries=1 --spider http://localhost:${var.prometheus_port}/-/healthy || exit 1"
          ]

          interval    = 30
          timeout     = 5
          retries     = 3
          startPeriod = 60
        }

        logConfiguration = {
          logDriver = "awslogs"

          options = {
            awslogs-group         = aws_cloudwatch_log_group.prometheus.name
            awslogs-region        = var.aws_region
            awslogs-stream-prefix = "prometheus"
          }
        }
      }
    ]
  )

  tags = merge(
    local.common_tags,
    {
      Name      = local.prometheus_task_family
      Component = "Prometheus"
    }
  )

  depends_on = [
    aws_efs_mount_target.prometheus,
    aws_s3_object.prometheus_config,
    aws_s3_object.backend_rules,
    aws_s3_object.alerts
  ]
}


# ============================================================
# PROMETHEUS ECS SERVICE
# ============================================================

resource "aws_ecs_service" "prometheus" {
  name = local.prometheus_service_name

  cluster = var.ecs_cluster_arn

  task_definition = aws_ecs_task_definition.prometheus.arn

  desired_count = var.prometheus_desired_count

  launch_type = "FARGATE"

  platform_version = "LATEST"

  enable_execute_command = false

  network_configuration {
    subnets = values(var.private_subnet_ids)

    security_groups = [
      aws_security_group.prometheus.id
    ]

    assign_public_ip = false
  }

  dynamic "service_registries" {
    for_each = [1]

    content {
      registry_arn = aws_service_discovery_service.prometheus.arn
    }
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  wait_for_steady_state = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  tags = merge(
    local.common_tags,
    {
      Name      = local.prometheus_service_name
      Component = "Prometheus"
    }
  )

  depends_on = [
    aws_efs_mount_target.prometheus,
    aws_s3_object.prometheus_config,
    aws_s3_object.backend_rules,
    aws_s3_object.alerts
  ]
}

# ============================================================
# PROMETHEUS CLOUD MAP SERVICE
# ============================================================

resource "aws_service_discovery_service" "prometheus" {
  name = var.prometheus_service_discovery_name

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${var.prometheus_service_discovery_name}.neonlens.internal"
      Component = "Prometheus"
    }
  )
}