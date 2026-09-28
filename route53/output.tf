# ============================================================
# HOSTED ZONE
# ============================================================

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID."
  value       = var.zone_id
}

output "hosted_zone_name" {
  description = "Route 53 hosted zone name."
  value       = var.domain_name
}


# ============================================================
# DNS RECORDS
# ============================================================

output "record_names" {
  description = "Map of created Route 53 record names."

  value = {
    for key, record in aws_route53_record.neonlens :
    key => record.name
  }
}


output "record_fqdns" {
  description = "Map of created Route 53 fully qualified domain names."

  value = {
    for key, record in aws_route53_record.neonlens :
    key => record.fqdn
  }
}