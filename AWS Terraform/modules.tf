#provider.tf

provider "aws" {
    region = "${var.AWS_REGION}"
}

module "git" {
    source = "github.com/mklabs/terraform-module-example.git"
}

module "local" {
    source   = "./mklabs/terraform-module-example"
    key_name = "${aws_key_pair.mykey.key_name}"
    key_path = "${var.PATH_TO_PRIVATE_KEY}"
}

output "ip-output" {
    value = "${module.local.server_address}"
}

#vars.tf

variable "AWS_REGION" {
    default = "ap-south-1"
}

variable "PATH_TO_PRIVATE_KEY" {
    default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
    default = "mykey.pub"
}

#output.tf

output "aws-cluster" {
    value = "${aws_instance.myec2.public_ip}"
}

#key.tf

resource "aws_key_pair" "mykey" {
    key_name = "mykey"
    public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}
