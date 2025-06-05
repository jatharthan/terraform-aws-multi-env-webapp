terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_dynamodb_table" "this" {
  provider     = aws
  name         = "${var.project_prefix}-${var.region}-${var.environment}-table"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"
  table_class  = "STANDARD"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags = {
    Name = "${var.project_prefix}-${var.region}-${var.environment}-table"
  }
}