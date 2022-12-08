#Terraform Settings Block
terraform {
  required_version = ">= 1.0.3"
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}


#Terraform Provider Block
provider "aws" {
    profile = "mklabs"
    region  = "ap-south-1"
}


#Terraform Resource for S3 Buckets creation
resource "aws_s3_bucket" "s3demobucket" {
    for_each = {
      "dev"  = "s3-dev-bucket"
      "test" = "s3-test-bucket"
      "qa"   = "s3-qa-bucket" 
    }

    bucket = "${each.key}-${each.value}"
    acl = "private"

    tags = {
        "Name"      = "${each.key}-${each.key}"
        "Eachvalue" = each.value
        "Eachkey"   = each.key
    }
}