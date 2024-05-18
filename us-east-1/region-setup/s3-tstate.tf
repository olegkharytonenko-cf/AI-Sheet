resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.resource_prefix}-${data.aws_region.current.name}-tf-state"
}

resource "aws_s3_bucket_versioning" "state-versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state-encryption" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

#not needed atm 5/20/24
# resource "aws_s3_bucket_lifecycle_configuration" "state-lifecycle" {
#   bucket = aws_s3_bucket.tf_state.id
#   rule {
#     id     = "state"
#     status = "Enabled"
#     abort_incomplete_multipart_upload {
#       days_after_initiation = 1
#     }
#     noncurrent_version_expiration {
#       noncurrent_days = "365"
#     }
#   }
# }

#cross account things
# resource "aws_s3_bucket_policy" "tfstate_bucket_policy" {
#   bucket = aws_s3_bucket.tf_state.bucket
#   policy = data.aws_iam_policy_document.tfstate_bucket_policy.json
# }

#cross account things
# data "aws_iam_policy_document" "tfstate_bucket_policy" {

#   dynamic "statement" {
#     for_each = var.application_account_numbers
#     content {
#       actions = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"]
#       effect  = "Allow"
#       principals {
#         identifiers = [statement.value]
#         type        = "AWS"
#       }
#       resources = ["${aws_s3_bucket.tf_state.arn}/*", aws_s3_bucket.tf_state.arn]
#     }
#   }
# }

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# resource "aws_s3_bucket_logging" "tf_state" {
#   bucket = aws_s3_bucket.tf_state.id

#   target_bucket = aws_s3_bucket.s3-accesslogs.id
#   target_prefix = "tf_state/"
# }
