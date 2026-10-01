# ============================================================
# ALB DNS RECORD
# ============================================================

resource "aws_route53_record" "neonlens" {
  for_each = var.records

  zone_id = var.zone_id

  name = each.value.name
  type = each.value.type

  ttl = each.value.alias == null ? each.value.ttl : null

  records = each.value.alias == null ? each.value.records : null

  set_identifier  = each.value.set_identifier
  allow_overwrite = var.allow_overwrite

  dynamic "alias" {
    for_each = each.value.alias == null ? [] : [each.value.alias]

    content {
      name                   = each.value.alias.dns_name
      zone_id                = each.value.alias.zone_id
      evaluate_target_health = each.value.alias.evaluate_target_health
    }
  }

  lifecycle {
    precondition {
      condition = each.value.alias == null ? (
        each.value.ttl != null &&
        length(each.value.records) > 0
        ) : (
        each.value.ttl == null &&
        length(each.value.records) == 0
      )

      error_message = "Each Route 53 record must define either ttl and records, or alias, but not both."
    }
  }
}