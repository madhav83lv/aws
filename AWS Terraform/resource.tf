provider "AWS" {
    access_key = ""
    secret_key = ""
    version = "~> 2.33"
}

variable "AWS_REGION" {
  type = string
}

variable "AMIS" {
  type           = map(string)
  default        = {
    ap-south-1   = "myami"
  }
}
resource "aws_instance" "ec2" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
}