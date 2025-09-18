terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }

  backend "s3" {
    bucket         = var.state_bucket      # da bootstrap
    key            = "terraform.tfstate"
    region         = var.region
    dynamodb_table = var.lock_table
    encrypt        = true
  }
}

provider "aws" { region = var.region }
