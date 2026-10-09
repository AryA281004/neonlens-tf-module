# ============================================================
# GRAFANA CLOUDWATCH LOG GROUP
# ============================================================

resource "aws_cloudwatch_log_group" "grafana" {
  name              = "/ecs/${local.grafana_name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    local.common_tags,
    {
      Name      = "/ecs/${local.grafana_name}"
      Component = "Grafana"
    }
  )
}


# ============================================================
# GRAFANA ECS TASK DEFINITION
# ============================================================

resource "aws_ecs_task_definition" "grafana" {
  family = local.grafana_task_family

  cpu    = var.grafana_cpu
  memory = var.grafana_memory

  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  execution_role_arn = aws_iam_role.grafana_execution.arn

  task_role_arn = aws_iam_role.grafana_task.arn


  # ----------------------------------------------------------
  # GRAFANA DATA
  # ----------------------------------------------------------

  volume {
    name = "grafana-data"

    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.grafana.id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.grafana.id
        iam             = "ENABLED"
      }
    }
  }


  # ----------------------------------------------------------
  # GRAFANA PROVISIONING CONFIGURATION
  # ----------------------------------------------------------

  volume {
    name = "grafana-provisioning"
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

        image = "public.ecr.aws/aws-cli/aws-cli:latest"

        essential = false

        command = [
          "s3",
          "cp",
          "s3://${aws_s3_bucket.prometheus_config.id}/grafana/datasources/grafana.ini.yml",
          "/provisioning/datasources/grafana.ini.yml"
        ]

        mountPoints = [
          {
            sourceVolume  = "grafana-provisioning"
            containerPath = "/provisioning"
            readOnly      = false
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"

          options = {
            awslogs-group         = aws_cloudwatch_log_group.grafana.name
            awslogs-region        = var.aws_region
            awslogs-stream-prefix = "config"
          }
        }
      },


      # ======================================================
      # GRAFANA
      # ======================================================

      {
        name = local.grafana_container_name

        image = var.grafana_image

        essential = true

        environment = [
          {
            name  = "GF_PATHS_DATA"
            value = "/var/lib/grafana"
          },
          {
            name  = "GF_PATHS_PROVISIONING"
            value = "/etc/grafana/provisioning"
          },
          {
            name  = "GF_SERVER_HTTP_PORT"
            value = tostring(var.grafana_port)
          }
        ]

        portMappings = [
          {
            containerPort = var.grafana_port
            hostPort      = var.grafana_port
            protocol      = "tcp"
          }
        ]

        mountPoints = [
          {
            sourceVolume  = "grafana-data"
            containerPath = "/var/lib/grafana"
            readOnly      = false
          },
          {
            sourceVolume  = "grafana-provisioning"
            containerPath = "/etc/grafana/provisioning"
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
            "wget --no-verbose --tries=1 --spider http://localhost:${var.grafana_port}/api/health || exit 1"
          ]

          interval    = 30
          timeout     = 5
          retries     = 3
          startPeriod = 60
        }

        logConfiguration = {
          logDriver = "awslogs"

          options = {
            awslogs-group         = aws_cloudwatch_log_group.grafana.name
            awslogs-region        = var.aws_region
            awslogs-stream-prefix = "grafana"
          }
        }
      }
    ]
  )

  tags = merge(
    local.common_tags,
    {
      Name      = local.grafana_task_family
      Component = "Grafana"
    }
  )

  depends_on = [
    aws_efs_mount_target.grafana,
    aws_s3_object.grafana_datasource
  ]
}


# ============================================================
# GRAFANA ECS SERVICE
# ============================================================

resource "aws_ecs_service" "grafana" {
  name = local.grafana_service_name

  cluster = var.ecs_cluster_arn

  task_definition = aws_ecs_task_definition.grafana.arn

  desired_count = var.grafana_desired_count

  launch_type = "FARGATE"

  platform_version = "LATEST"

  enable_execute_command = false

  network_configuration {
    subnets = values(var.private_subnet_ids)

    security_groups = [
      aws_security_group.grafana.id
    ]

    assign_public_ip = false
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
      Name      = local.grafana_service_name
      Component = "Grafana"
    }
  )

  depends_on = [
    aws_efs_mount_target.grafana,
    aws_s3_object.grafana_datasource
  ]
}