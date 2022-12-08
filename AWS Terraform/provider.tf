#provider.tf

provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "${var.AWS_REGION}"
}

#vars.tf

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
default = "ap-south-1"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1  = "ami-"
    ap-south-1 = "ami-"
    eu-west-1  = "ami-"
  }
}

#terraform.tfvars

AWS_ACCESS_KEY = ""
AWS_SECRET_KEY = ""
AWS_REGION     = ""

#instance.tf

resource "aws_instance" "myec2" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
}