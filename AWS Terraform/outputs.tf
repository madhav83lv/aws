#instance.tf

resource "aws_instance" "myec2" {
    ami = "${lookup(var.AMIS, var.AWS_REGION)}"
    instance_type = "t2.micro"
    provisioner "local-exec" {
        command = "echo ${aws_instance.myec2.public_ip} >> private_ips.txt"
}
}

output "ip" {
  value = aws_instance.myec2.public_ip
}

#provider.tf

provider "aws" {
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
    region = var.AWS_REGION
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
    us-east-1 = "ami-"
    us-west-2 = "ami-"
    ap-south-1 = "ami-"
  }
}