#rds.tf

resource "aws_db_subnet_group" "mariadb-subnet" {
  name = "mariadb-subnet"
  description = "RDS Subnet Group"
  subnet_ids = [aws_subnet.main-private-1.id, aws_subnet.main-private-2.id]
}

resource "aws_db_parameter_group" "mariadb-parameters" {
  name = "mariadb-parameters"
  family = "mariadb10.1"
  description = "MariaDB parameter group"

  parameter {
    name = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "mariadb" {
  allocated_storage = 100
  engine            = "mariadb"
  engine_version    = "10.1.14"
  instance_class    = "db.t2.small"
  identifier        = "mariadb"
  name              = "mariadb"
  username          = "root"
  password          = var.RDS_PASSWORD
  db_subnet_group_name  = aws_db_subnet_group.mariadb-subnet.name
  parameter_group_name  = "mariadb-parameters"
  multi_az          = "false"
  vpc_security_group_ids = aws_security_group.allow-mariadb.id
  storage_type      = "gp2"
  backup_retention_period = 30
  availability_zone = aws_subnet.main-private-1.availability_zone
  tags {
    Name = "mariadb-instance"
  }
}

#vpc.tf
#Internet VPC

resource "aws_vpc" "vpc_main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support =   true
  enable_classiclink = false

  tags {
    Name = "vpc_main"
  }
}

#Subnets
#Public Subnets

resource "aws_subnet" "main-public-1" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"

  tags {
    Name = "main-public-1"
  }
}

resource "aws_subnet" "main-public-2" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1b"

  tags {
    Name = "main-public-2"
  }
}

resource "aws_subnet" "main-public-3" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1c"

  tags {
    Name = "main-public-3"
  }
}

#Private Subnets

resource "aws_subnet" "main-private-1" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-south-1a"

  tags {
    Name = "main-private-1"
  }
}

resource "aws_subnet" "main-private-2" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-south-1b"

  tags {
    Name = "main-private-2"
  }
}

resource "aws_subnet" "main-private-3" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-south-1c"

  tags {
    Name = "main-private-3"
  }
}

#Internet Gateway

resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.vpc_main.id

  tags {
    Name = "main-gw"
  }
}

#Route tables

resource "aws_route_table" "main-public" {
    vpc_id = aws_vpc.vpc_main.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main-gw.id
    }

    tags {
      Name = "main-public"
    }
}

#Route Association to Public Subnet

resource "aws_route_table_association" "route-public-1" {
    subnet_id = aws_subnet.main-public-1.id
    route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "route-public-2" {
    subnet_id = aws_subnet.main-public-2.id
    route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "route-public-3" {
    subnet_id = aws_subnet.main-public-3.id
    route_table_id = aws_route_table.main-public.id
}

#NAT Gateway

resource "aws_eip" "nat-eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.main-public-1.id
  depends_on = [
    aws_internet_gateway.main-gw
  ]
}

#VPC Setup for NAT Gateway

resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  } 
  tags {
    Name = "main-private"
  }
}

#Route Associations Private

resource "aws_route_table_association" "route-private-1" {
  subnet_id = aws_subnet.main-private-1.id
  route_table_id = aws_route_table.main-private.id
}

resource "aws_route_table_association" "route-private-2" {
  subnet_id = aws_subnet.main-private-2.id
  route_table_id = aws_route_table.main-private.id
}

resource "aws_route_table_association" "route-private-3" {
  subnet_id = aws_subnet.main-private-3.id
  route_table_id = aws_route_table.main-private.id
}

#vars.tf

variable "AWS_ACCESS_KEY" {
  
}

variable "AWS_SECRET_KEY" {
  
}

variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "AMIS" {
  type = "map"
  default = {
    ap-south-1a = "ami-"
    ap-south-1b = "ami-"
    ap-south-1c = "ami-"
  }
}


#instance.tf

resource "aws_instance" "example" {
    ami              = "${lookup(var.AMIS, var.AWS_REGION)}"
    instance_type    = "t2.micro"
    subnet_id        = aws_subnet.main-public-1.id
    vpc_security_group_ids  = aws_security_group.allow-ssh.id
    key_name            = aws_key_pair.mykey.key_name
}


#securitygroup.tf

resource "aws_security_group" "allow-ssh" {
  vpc_id = aws_vpc.vpc_main.id
  name = "allow-ssh"
  description = "Security Group that allows SSH and Egress traffic"

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 1
  }

  ingress {
    cidr_blocks = [ "0.0.0.0/0"]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }

  tags {
    Name = "allow-ssh"
  }
}

resource "aws_security_group" "allow-mariadb" {
    vpc_id      = aws_vpc.vpc_main.id
    name        = "allow-mariadb"
    description = "allow-mariadb"

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        self       = true
    }

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = aws_security_group.allow-ssh.id
    }

    tags {
        Name = "allow-mariadb"
    }
}

#keypairs.tf

resource "aws_key_pair" "mykey" {
  key_name = "mykeypair"
  public_key = "${file("keys/mykeypair.pub")}"
}

#outputs.tf

output "instance" {
    value = aws_instance.example.public_ip
}

output "rds" {
    value = aws_db_instance.mariadb.endpoint
}
