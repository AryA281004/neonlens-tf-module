# ============================================================
# CLOUDFRONT ORIGIN ACCESS CONTROL
# ============================================================

resource "aws_cloudfront_origin_access_control" "neonlens" {
  name                              = "${var.environment}-${var.name}-oac"
  description                       = "Origin Access Control for ${var.environment}-${var.name} S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


# ============================================================
# CLOUDFRONT DISTRIBUTION
# ============================================================

resource "aws_cloudfront_distribution" "neonlens" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.environment}-${var.name} CloudFront distribution"
  default_root_object = var.default_root_object
  price_class         = var.price_class

  aliases = var.aliases

  # ----------------------------------------------------------
  # S3 ORIGIN
  # ----------------------------------------------------------

  origin {
    domain_name              = aws_s3_bucket.neonlens.bucket_regional_domain_name
    origin_id                = "${var.environment}-${var.name}-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.neonlens.id
  }

  # ----------------------------------------------------------
  # DEFAULT CACHE BEHAVIOR
  # ----------------------------------------------------------

  default_cache_behavior {
    target_origin_id = "${var.environment}-${var.name}-s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]

    cached_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]

    compress = true

    cache_policy_id          = var.cache_policy_id
    origin_request_policy_id = var.origin_request_policy_id
  }

  # ----------------------------------------------------------
  # CUSTOM ERROR RESPONSES
  # ----------------------------------------------------------

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses

    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  # ----------------------------------------------------------
  # TLS / HTTPS
  # ----------------------------------------------------------

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null

    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method      = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version = var.acm_certificate_arn != null ? var.minimum_protocol_version : null
  }

  # ----------------------------------------------------------
  # RESTRICTIONS
  # ----------------------------------------------------------

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  # ----------------------------------------------------------
  # LOGGING
  # ----------------------------------------------------------

  dynamic "logging_config" {
    for_each = var.enable_cloudfront_logging ? [1] : []

    content {
      bucket          = var.logging_bucket
      prefix          = var.logging_prefix
      include_cookies = var.logging_include_cookies
    }
  }

  # ----------------------------------------------------------
  # WAIT FOR DISTRIBUTION
  # ----------------------------------------------------------

  wait_for_deployment = var.wait_for_deployment

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-${var.name}-cloudfront"
    }
  )
}


# ============================================================
# S3 BUCKET POLICY
# Allow ONLY this CloudFront distribution to access S3
# ============================================================

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.neonlens.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"

        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action = [
          "s3:GetObject"
        ]

        Resource = "${aws_s3_bucket.neonlens.arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.neonlens.arn}"
          }
        }
      }
    ]
  })

  depends_on = [
    aws_cloudfront_origin_access_control.neonlens
  ]
}