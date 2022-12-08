terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
    profile = "mklabs"
}

#alis

provider "aws" {
    alias = "mumbai"
    region = "us-east-1"
    profile = "mklabs1"
}

resource "aws_instance" "web_app" {
    provider = aws.mumbai
  
}

resource "aws_vpc" {
    source = "./aws_vpc"
    provider = {
        aws = aws.mumbai
    }
  
}

#backend

terraform {
  required_providers {
    aws = {
        version = "~> 3.0"
        source  = "hashicorp/aws"
    }
  }

backend "s3" {
    bucket = "mybucket"
    key    = "path/to/key"
    region = "ap-south-1"
    }
}