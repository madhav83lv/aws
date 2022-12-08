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


#Resource Block for IAM Users creation
resource "aws_iam_user" "demousers" {
    for_each = toset(["mklabs1", "mklabs2", "mklabs3"])
    name = each.key
}