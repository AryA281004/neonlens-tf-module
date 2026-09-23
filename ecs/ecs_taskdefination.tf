# ============================================================
# ECS TASK DEFINITION
# ============================================================

resource "aws_ecs_task_definition" "neonlens" {
  family = local.task_family

  cpu    = var.task_cpu
  memory = var.task_memory

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "${local.container_name}"
      image     = "${var.container_image}"
      essential = true

      cpu    = "${var.container_cpu}"
      memory = "${var.container_memory}"

      portMappings = [
        {
          name          = "${var.name}-port"
          containerPort = "${var.container_port}"
          hostPort      = "${var.container_port}"
          protocol      = "tcp"
        }
      ]

      environment = "${local.container_environment}"

      secrets = "${local.container_secrets}"

      healthCheck = "${var.enable_container_health_check}" ? {
        command = "${var.container_health_check_command}"

        interval = "${var.container_health_check_interval}"
        timeout  = "${var.container_health_check_timeout}"
        retries  = "${var.container_health_check_retries}"
        startPeriod = "${var.container_health_check_start_period}"
      } : null

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = "${aws_cloudwatch_log_group.neonlens.name}"
          awslogs-region        = "${var.aws_region}"
          awslogs-stream-prefix = "${var.log_stream_prefix}"
        }
      }

      readonlyRootFilesystem = "${var.readonly_root_filesystem}"

      stopTimeout = "${var.container_stop_timeout}"
    }
  ])

  dynamic "runtime_platform" {
    for_each = var.cpu_architecture != null || var.operating_system_family != null ? [1] : []

    content {
      cpu_architecture        = var.cpu_architecture
      operating_system_family = var.operating_system_family
    }
  }

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_gib != null ? [1] : []

    content {
      size_in_gib = var.ephemeral_storage_gib
    }
  }

  tags = merge(
    local.common_tags,
    {
      Component = "TaskDefinition"
    }
  )
}