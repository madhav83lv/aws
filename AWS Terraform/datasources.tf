#datasources.tf

data "aws_ip_ranges" "asia_ec2" {
    regions = ["eu-west-1", "ap-south-1"]
    services = ["ec2"]
}

resource "aws_security_group" "from_asia" {
    name = "from_asia"

    ingress {
        from_port = "443"
        to_port = "443"
        protocol = "tcp"
        cidr_blocks = ["${data.aws_ip_ranges.asia_ec2.cidr_blocks}"]
    }
    tags {
        CreateDate = "${data.aws_ip_ranges.asia_ec2.create_date}"
        SyncToken  = "${data.aws_ip_ranges.asia_ec2.sync_token}"
    }
}


#provider.tf

provider "aws" {
    region = "${var.AWS_REGION}"
}

#vars.tf

variable "AWS_REGION" {
    default = "ap-south-1"
}

variable "AMIS" {
    type = "map"
    default = {
        us-east-1  = "ami-"
        ap-south-1 = "ami-"
    }
}