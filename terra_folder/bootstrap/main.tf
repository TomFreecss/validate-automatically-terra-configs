terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "tfstate" {
  bucket = var.bucket_name
  acl    = "private"
  force_destroy = true
}

resource "aws_dynamodb_table" "lock" {
  name         = var.lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = { Name = "terraform-lock" }
}

output "bucket_name" { value = aws_s3_bucket.tfstate.bucket }
output "dynamodb_table" { value = aws_dynamodb_table.lock.name }