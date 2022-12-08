#Provider Block
terraform {
  required_version = ">= 1.0.3"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "bucket-name"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-dev-state-table"
  }
}

provider "aws" {
    region = "ap-south-1"
    profile = "default"
}

#Variables
variable "aws_region" {
    description = "Region on which aws resource to be created"
    type = string
    default = "ap-south-1"
}

variable "az_name" {
    description = "Availability Zone name"
    type = string
    default = "ap-south-1a"
}

variable "ami_name" {
    description = "Latest AMI ID on ap-south-1"
    type = string
    default = "ami-"
}

variable "inst_type" {
    description = "Instance type used to Launch EC2 Instance"
    type = string
    default = "t2.micro"
}

variable "inst_count" {
    description = "Number of EC2 Instances to be created"
    type = Number
    default = 1
}

#resource
resource "aws_instance" "web" {
    ami = var.ami_name
    instance_type = var.inst_type
    count = var.inst_count
    availability_zone = var.az_name

    tags = {
      "Name" = "Webapp-terraform"
    }
}