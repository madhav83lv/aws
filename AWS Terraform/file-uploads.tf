#instance.tf

resource "aws_key_pair" "mumbai-key" {
  key_name = "mykey"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "myec2" {
    ami = "${lookup(var.AMIS, var.AWS_REGION)}"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.mykey.key_name}"

    provisioner "file" {
        source = "script.sh"
        destination = "/tmp/script.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/script.sh",
            "sudo /tmp/script.sh"
        ]
    }

        connection {
            user = "${var.INSTANCE_USERNAME}"
            private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
        }
    }


#vars.terraform 
    
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
        }
    }

    variable "PATH_TO_PRIVATE_KEY" {
      default = "mykey"
    }

    variable "PATH_TO_PUBLIC_KEY" {
      default = "mykey.pub"
    }

    variable "INSTANCE_USERNAME" {
        default = "ubuntu"
    }