# ============================================================
# GENERAL
# ============================================================

variable "environment" {
  description = "Environment name such as dev, staging, or production."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "environment must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "name" {
  description = "Logical application/resource name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "name must contain only lowercase letters, numbers, and hyphens."
  }
}


# ============================================================
# S3
# ============================================================

variable "bucket_name" {
  description = "Globally unique S3 bucket name. If null, Terraform generates one using environment, name, and AWS account ID."
  type        = string
  default     = null

  validation {
    condition = (
      var.bucket_name == null ||
      can(regex(
        "^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$",
        var.bucket_name
      ))
    )

    error_message = "bucket_name must be null or a valid S3 bucket name."
  }
}

variable "force_destroy" {
  description = "Whether Terraform should delete all objects when destroying the bucket."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable S3 object versioning."
  type        = bool
  default     = true
}


# ============================================================
# ENCRYPTION
# ============================================================

variable "sse_algorithm" {
  description = "S3 server-side encryption algorithm."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm must be either AES256 or aws:kms."
  }
}

variable "kms_key_arn" {
  description = "KMS key ARN when using aws:kms encryption."
  type        = string
  default     = null
}


# ============================================================
# LIFECYCLE
# ============================================================

variable "noncurrent_version_expiration_days" {
  description = "Days before noncurrent object versions are permanently deleted."
  type        = number
  default     = 30

  validation {
    condition     = var.noncurrent_version_expiration_days >= 1
    error_message = "noncurrent_version_expiration_days must be at least 1."
  }
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Days before incomplete multipart uploads are aborted."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_upload_days >= 1
    error_message = "abort_incomplete_multipart_upload_days must be at least 1."
  }
}


# ============================================================
# CLOUDWATCH
# ============================================================

variable "enable_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms for S3 bucket metrics."
  type        = bool
  default     = true
}

variable "bucket_size_alarm_threshold_gb" {
  description = "S3 bucket size threshold in GB."
  type        = number
  default     = 10

  validation {
    condition     = var.bucket_size_alarm_threshold_gb > 0
    error_message = "bucket_size_alarm_threshold_gb must be greater than 0."
  }
}

variable "object_count_alarm_threshold" {
  description = "Maximum number of objects before the CloudWatch alarm triggers."
  type        = number
  default     = 100000

  validation {
    condition     = var.object_count_alarm_threshold > 0
    error_message = "object_count_alarm_threshold must be greater than 0."
  }
}


# ============================================================
# SNS
# ============================================================

variable "enable_sns_notifications" {
  description = "Create SNS topic and connect CloudWatch alarms to it."
  type        = bool
  default     = true
}

variable "notification_email" {
  description = "Email address subscribed to the SNS topic."
  type        = string
  default     = null

  validation {
    condition = (
      var.notification_email == null ||
      can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.notification_email))
    )

    error_message = "notification_email must be a valid email address."
  }
}


# ============================================================
# TAGS
# ============================================================

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}

# ============================================================
# CLOUDFRONT
# ============================================================

variable "default_root_object" {
  description = "Default object served by CloudFront"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"

  validation {
    condition = contains(
      [
        "PriceClass_All",
        "PriceClass_200",
        "PriceClass_100"
      ],
      var.price_class
    )

    error_message = "price_class must be PriceClass_All, PriceClass_200, or PriceClass_100."
  }
}

variable "aliases" {
  description = "Custom domain names for the CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS custom domains. Certificate must be in us-east-1."
  type        = string
  default     = null
}

variable "minimum_protocol_version" {
  description = "Minimum TLS protocol version for CloudFront"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "cache_policy_id" {
  description = "CloudFront cache policy ID"
  type        = string
  default     = null
}

variable "origin_request_policy_id" {
  description = "CloudFront origin request policy ID"
  type        = string
  default     = null
}


# ============================================================
# CLOUDFRONT ERROR RESPONSES
# ============================================================

variable "custom_error_responses" {
  description = "Custom CloudFront error responses"
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))

  default = [
    {
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 0
    },
    {
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 0
    }
  ]
}


# ============================================================
# GEO RESTRICTION
# ============================================================

variable "geo_restriction_type" {
  description = "CloudFront geographic restriction type"
  type        = string
  default     = "none"

  validation {
    condition = contains(
      [
        "none",
        "whitelist",
        "blacklist"
      ],
      var.geo_restriction_type
    )

    error_message = "geo_restriction_type must be none, whitelist, or blacklist."
  }
}

variable "geo_restriction_locations" {
  description = "Countries for CloudFront geographic restriction"
  type        = list(string)
  default     = []
}


# ============================================================
# CLOUDFRONT LOGGING
# ============================================================

variable "enable_cloudfront_logging" {
  description = "Enable CloudFront access logging"
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "S3 bucket domain name used for CloudFront logs"
  type        = string
  default     = null
}

variable "logging_prefix" {
  description = "Prefix for CloudFront logs"
  type        = string
  default     = ""
}

variable "logging_include_cookies" {
  description = "Include cookies in CloudFront access logs"
  type        = bool
  default     = false
}


# ============================================================
# CLOUDFRONT DEPLOYMENT
# ============================================================

variable "wait_for_deployment" {
  description = "Wait for CloudFront distribution deployment to complete"
  type        = bool
  default     = true
}