locals{

    name_prefix = "${var.environment}-${var.name}"
    
    common_tags = merge(
        {
        Environment = "${var.environment}"
        Project     = "${var.name}"
        ManagedBy   = "Terraform"
        Component   = "Route53"
        },
        var.tags
    )
    
    zone_name = "${local.name_prefix}.com"
}