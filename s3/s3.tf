# ============================================================
# DATA
# ============================================================

data "aws_caller_identity" "current" {}


# ============================================================
# LOCALS
# ============================================================

locals {
  common_tags = merge(
    {
      Environment = "${var.environment}"
      Project     = "${var.name}"
      ManagedBy   = "Terraform"
    },
    var.tags
  )

  bucket_name = coalesce(
    var.bucket_name,"${var.environment}-${var.name}-frontend-${data.aws_caller_identity.current.account_id}"
  )
}

# ============================================================
# S3 BUCKET
# ============================================================

resource "aws_s3_bucket" "neonlens" {
  bucket = local.bucket_name
  force_destroy = var.force_destroy

  tags = merge(local.common_tags, {
    Name      = "${local.bucket_name}"
    Component = "Frontend"
  })
}


# ============================================================
# S3 OWNERSHIP
# ============================================================

resource "aws_s3_bucket_ownership_controls" "neonlens" {
  bucket = aws_s3_bucket.neonlens.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


# ============================================================
# S3 PUBLIC ACCESS BLOCK
# ============================================================

resource "aws_s3_bucket_public_access_block" "neonlens" {
  bucket = aws_s3_bucket.neonlens.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# ============================================================
# S3 VERSIONING
# ============================================================

resource "aws_s3_bucket_versioning" "neonlens" {
  bucket = aws_s3_bucket.neonlens.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}


# ============================================================
# S3 ENCRYPTION
# ============================================================

resource "aws_s3_bucket_server_side_encryption_configuration" "neonlens" {
  bucket = aws_s3_bucket.neonlens.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.kms_key_arn : null
    }

    bucket_key_enabled = var.sse_algorithm == "aws:kms"
  }
}


# ============================================================
# S3 LIFECYCLE
# ============================================================

resource "aws_s3_bucket_lifecycle_configuration" "neonlens" {
  bucket = aws_s3_bucket.neonlens.id

  rule {
    id     = "neonlens-lifecycle"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_incomplete_multipart_upload_days
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.neonlens
  ]
}