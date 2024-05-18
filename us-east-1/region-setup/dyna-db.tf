# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb_" {
  #checkov:skip=CKV2_AWS_16: "Ensure that Auto Scaling is enabled on your DynamoDB tables" - Not needed for Terraform state lock
  #checkov:skip=CKV_AWS_28: "Ensure Dynamodb point in time recovery (backup) is enabled" - Not needed for Terraform state lock
  name           = "${var.resource_prefix}-${data.aws_region.current.name}-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
  depends_on = [aws_s3_bucket.tf_state]
}
