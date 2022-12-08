#Provider Block
terraform {
  required_version = "~> 1.0.3"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
        profile = "default"
        region = "ap-south-1"
}


#security-group.tf
resource "aws_security_group" "allow_http_ssh" {
    name        = "allow-http-ssh"
    description = "Allow Ingress rules to allow SSH and HTTP connections"
}


#Security group rule
resource "aws_security_group_rule" "ingress_ssh" {
        type = "ingress"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_group_id = aws_security_group.allow_http_ssh.id
}

resource "aws_security_group_rule" "ingress_http" {
        type = "ingress"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_group_id = aws_security_group.allow_http_ssh.id
}

resource "aws_security_group_rule" "egress_allow_all" {
        type = "egress"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        security_group_id = aws_security_group.allow_http_ssh.id
}

#Outputs
output "ec2_instance_private_ip" {
        value = aws_instance.web.private_ip
        description = "EC2 Instance Private IP"
}

output "ec2_instance_public_ip" {
        value = aws_instance.web.public_ip
        description = "EC2 Instance Public IP"
}

output "ec2_instance_public_dns" {
        value = "http://${aws_instance.web.public_dns}"
        description = "EC2 Instance Public DNS"
        sensitive = true
}

#instance
resource "aws_instance" "web" {
        ami = "${data.aws_ami.ubuntu_ami.id}" //ami-
        instance_type = var.inst_type
        availability_zone = var.az_name
        user_data = file("nginx-install.sh")
        vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
}

#variables
variable "aws_region" {
        description = "Region on which resources to be creted"
        type = string
        default = "ap-south-1"
}

variable "az_name" {
        description = "Availability Zone"
        type = string
        default = "ap-south-1a"
}

variable "inst_type" {
        description = "Instance type used to launch EC2 Instance"
        type = string
        default = "t2.micro"
}

#Datasource
data "aws_ami" "ubuntu_ami" {
        most_recent = true
        owners = ["099720109477"]

        filter {
          name = "name"
          values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
        }

        filter {
          name = "root-device-type"
          values = ["ebs"]
        }

        filter {
          name = "virtualization-type"
          values = ["hvm"]
        }

        filter {
          name = "architecture"
          values = ["x86_64"]
        }
}