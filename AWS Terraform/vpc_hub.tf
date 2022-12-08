#Terraform Settings Block
terraform {
  required_version = ">= 1.0.3"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}


#Terraform Provider Block
provider "aws" {
    profile = "mklabs"
    region = "ap-south-1"
}


#Resource Block for VPC Creation
resource "aws_vpc" "my_vpc" {
    cidr_block           = "192.168.0.0/16"
    enable_dns_hostnames = true

    tags = {
      "Name" = "Terraform-VPC"
    }
}



#Resource Block for Subnets creation
resource "aws_subnet" "public_subnet" {
        vpc_id = aws_vpc.my_vpc.id
        cidr_block              = "192.168.1.0/24"
        availability_zone       = "us-east-1a"
        map_public_ip_on_launch = true

        tags = {
          "Name" = "Public-Subnet"
        }
}

resource "aws_subnet" "private_subnet" {
        vpc_id            = aws_vpc.my_vpc.id
        cidr_block        = "192.168.2.0/24"
        availability_zone = "us-east-1b"

        tags = {
          "Name" = "Private-Subnet"
        }
}


#Resource Block for Internet Gateway Creation
resource "aws_internet_gateway" "igw" {
        vpc_id = aws_vpc.my_vpc.id

        tags = {
          "Name" = "Internet-Gateway"
        } 
}


#Resource Block for Route Table
#Public Route Table
resource "aws_route_table" "Public_route_table" {
        vpc_id = aws_vpc.my_vpc.id

        tags = {
          "Name" = "Public-Route"
        }
}

#Private Route Table
resource "aws_route_table" "Private_route_table" {
        vpc_id = aws_vpc.my_vpc.id

        tags = {
          "Name" = "Private-Route"
        }
}

#Public Route
resource "aws_route" "Public_route" {
        route_table_id         = aws_route_table.Public_route_table.id
        destination_cidr_block = "0.0.0.0/0"
        gateway_id             = aws_internet_gateway.igw.id
        depends_on = [
          aws_internet_gateway.igw
        ]
}

#Public Route Table Association
resource "aws_route_table_association" "Public_Route_table_association" {
        subnet_id      = aws_subnet.public_subnet.id
        route_table_id = aws_route_table.Public_route_table.id
}

#Private Route Table Association
resource "aws_route_table_association" "Private_Route_table_association" {
        subnet_id      = aws_subnet.private_subnet.id
        route_table_id = aws_route_table.Private_route_table.id
}


#Security Group
resource "aws_security_group" "allow_http_ssh" {
        name        = "allow-http-ssh"
        description = "Allow Ingress rules to allow SSH and HTTP connection"
        vpc_id      = aws_vpc.my_vpc.id
}

resource "aws_security_group_rule" "ingres_ssh" {
        type              = "ingress"
        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        cidr_blocks       = [ "0.0.0.0/0" ]
        security_group_id = aws_security_group.allow_http_ssh.id
}

resource "aws_security_group_rule" "ingress_http" {
        type              = "ingress"
        from_port         = 80
        to_port           = 80
        protocol          = "tcp"
        cidr_blocks       = [ "0.0.0.0/0" ]
        security_group_id = aws_security_group.allow_http_ssh.id
}

resource "aws_security_group_rule" "egress_allow_all" {
        type              = "egress"
        from_port         = 0
        to_port           = 0
        protocol          = "-1"
        cidr_blocks       = [ "0.0.0.0/0" ]
        security_group_id = aws_security_group.allow_http_ssh.id
}


#Resource Block for EC2 Instance creation
resource "aws_instance" "web" {
        ami                         = "ami-"
        instance_type               = "t2.micro"
        key_name                    = "mumbai_key"
        subnet_id                   = aws_subnet.public_subnet.id
        vpc_security_group_ids      = [aws_security_group.allow_http_ssh.id]
        user_data                   = file("nginx-install.sh")
        availability_zone           = "us-east-1a"
        associate_public_ip_address = true
        count                       = 5 #We can Commit "availability_zone"

        tags = {
          "Name" = "WebApp-terraform"
          "Name" = "Nginx-${count.index}"
        }
}


#Resource Block for Elastic IP
resource "aws_eip" "demo-eip" {
        instance = aws_instance.web.id
        vpc      = true
        depends_on = [
          aws_internet_gateway.igw
        ]
}