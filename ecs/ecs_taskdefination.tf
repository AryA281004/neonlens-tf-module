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



  container_definitions = templatefile(
    "${path.module}/container-definitions.tftpl",
    {
      container_name   = local.container_name
      container_image  = var.container_image
      essential        = true
      container_cpu    = var.container_cpu
      container_memory = var.container_memory
      port_name        = "${var.name}-port"
      container_port   = var.container_port

      container_environment = jsonencode(local.container_environment)
      container_secrets     = jsonencode(local.container_secrets)

      health_check = var.enable_container_health_check ? jsonencode({
        command     = local.container_health_check_command
        interval    = var.container_health_check_interval
        timeout     = var.container_health_check_timeout
        retries     = var.container_health_check_retries
        startPeriod = var.container_health_check_start_period
      }) : jsonencode(null)

      log_group_name           = aws_cloudwatch_log_group.neonlens.name
      aws_region               = var.aws_region
      log_stream_prefix        = var.log_stream_prefix
      readonly_root_filesystem = var.readonly_root_filesystem
      container_stop_timeout   = var.container_stop_timeout

      enable_blackbox_exporter = var.enable_blackbox_exporter

      blackbox_container_definition = var.enable_blackbox_exporter ? jsonencode({
        name      = "${local.name_prefix}-blackbox-exporter"
        image     = var.blackbox_exporter_image
        essential = false
        cpu       = var.blackbox_exporter_cpu
        memory    = var.blackbox_exporter_memory

        portMappings = [
          {
            name          = "${var.name}-blackbox-port"
            containerPort = 9115
            hostPort      = 9115
            protocol      = "tcp"
          }
        ]

        command = [
          "--config.file=/etc/blackbox_exporter/config.yml",
          "--web.listen-address=:9115"
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            "awslogs-group"         = aws_cloudwatch_log_group.neonlens.name
            "awslogs-region"        = var.aws_region
            "awslogs-stream-prefix" = "${var.log_stream_prefix}-blackbox"
          }
        }

        readonlyRootFilesystem = true
        stopTimeout            = var.container_stop_timeout
      }) : ""
    }
  )



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