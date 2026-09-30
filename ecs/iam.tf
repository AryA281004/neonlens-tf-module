# ============================================================
# ECS TASK EXECUTION ROLE
# ============================================================

resource "aws_iam_role" "execution" {
  name = local.execution_role_name

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
# ECS TASK EXECUTION MANAGED POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ============================================================
# ECS EXECUTION ROLE - SECRETS MANAGER
# ============================================================

resource "aws_iam_role_policy" "execution_secrets" {
  count = length(var.execution_secret_arns) > 0 ? 1 : 0

  name = "${local.name_prefix}-execution-secrets"

  role = aws_iam_role.execution.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = var.execution_secret_arns
      }
    ]
  })
}


# ============================================================
# ECS TASK ROLE
# ============================================================

resource "aws_iam_role" "task" {
  name = local.task_role_name

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
# TASK ROLE POLICIES
# ============================================================

resource "aws_iam_role_policy_attachment" "task" {
  for_each = toset(var.task_role_policy_arns)

  role       = aws_iam_role.task.name
  policy_arn = each.value
}


# ============================================================
# ECS EXEC IAM POLICY
# ============================================================

resource "aws_iam_role_policy" "ecs_exec" {
  count = var.enable_execute_command ? 1 : 0

  name = "${local.name_prefix}-ecs-exec"

  role = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]

        Resource = "*"
      }
    ]
  })
}