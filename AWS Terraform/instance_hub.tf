#Terraform Settings Block
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
  required_version = ">= 0.14.9"
}


#Terraform Provider Block
provider "aws" {
    profile = "mklabs"
    region = "ap-south-1"
}


#Terraform Resource Block
resource "aws_instance" "web_app" {
    ami = "ami-"
    instance_type = "t2.micro"

    tags = {
      Name = "Webapp-terraform"
      Env  = "Production"
    }
}