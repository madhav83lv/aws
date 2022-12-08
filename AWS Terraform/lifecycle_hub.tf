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

#Terraform Resource Block with Lifecycle "Create Before Destroy"
resource "aws_instance" "web-app" {
    ami = "ami-"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
    #availability_zone = "ap-south-1b"

    tags = {
      "Name" = "WebApp-Terraform"
    }

    lifecycle {
      create_before_destroy = true
    }
}


#Terraform Resource Block with Lifecycle "Prevent Destroy"
resource "aws_instance" "web-app" {
    ami = "ami-"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
    #availability_zone = "ap-south-1b"

    tags = {
      "Name" = "WebApp-Terraform"
    }

    lifecycle {
      prevent_destroy = true
    }
}


#Terraform Resource Block with Lifecycle "Ignore Changes"
resource "aws_instance" "web-app" {
    ami = "ami-"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
    #availability_zone = "ap-south-1b"

    tags = {
      "Name" = "WebApp-Terraform"
    }

    lifecycle {
      ignore_changes = [
        ami,
        tags,
      ]
    }
}