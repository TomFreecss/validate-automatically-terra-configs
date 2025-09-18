variable "region" { 
    description = "AWS region"
    type = string
    default = "eu-west-1"
}

variable "bucket_name" { 
    description = "S3 bucket name for terraform state (unique globally)" 
    type = string
    default = "tomfreecss-terra-state"
}

variable "lock_table" {
    description = "DynamoDB to lock state"
    type = string
    default = "terraform-lock"
 }


