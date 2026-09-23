# ============================================================
# ECS CLUSTER
# ============================================================

resource "aws_ecs_cluster" "neonlens" {
  name = local.cluster_name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enhanced" : "disabled"
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.cluster_name}"
      Component = "Cluster"
    }
  )
}
