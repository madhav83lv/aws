#provider.tf
terraform {
  required_version = "= 1.2.8" #we can remove this line
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
    region  = var.aws_region
    profile = "default"
}


#variables.tf
variable "aws_region" {
    description = "Region on which the resource to be created"
    type        = string
    default     = "us-east-1"
}

variable "az_name" {
    description = "Availability Zone for the resource"
    type        = string
    default     = "us-east-1a"
}

variable "ami_name" {
    description = "Latest AMI Id on us-east-1"
    type        = string
    default     = "ami-"
}

variable "inst_type" {
    description = "Instance type used to launch EC2 Instance"
    type        = string
    default     = "t2.micro"
}

variable "inst_count" {
    description = "Number of Instances to be launched"
    type        = Number
    default     = 1
}


#ec2-auto.tfvars
inst_type  = "t3.large"
inst_count = 5


#instance.tf
resource "aws_instance" "web" {
    ami                         = var.ami_name
    instance_type               = var.inst_type
    count                       = var.inst_count
    availability_zone           = var.az_name
    user_data                   = file("nginx-install.sh")
    key_name                    = "mumbai_mklabs"
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.allow_http_ssh.id]

    tags = {
      "Name" = "WebApp-Terraform"
    }
  
}


#security-group.tf
resource "aws_security_group" "allow_http_ssh" {
    name        = "allow-http-ssh"
    description = "Allow Ingress rules to allow SSH and HTTP connections"
}

#security-group-rules.tf
resource "aws_security_group_rule" "ingress_ssh" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.allow_http_ssh.id
}

resource "aws_security_group_rule" "ingress_http" {
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.allow_http_ssh.id
}

resource "aws_security_group_rule" "egress_allow_all" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.allow_http_ssh.id
}


#terraform.tfvars
inst_count=5
inst_type=t2.small