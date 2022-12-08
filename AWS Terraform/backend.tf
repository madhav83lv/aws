terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "terraform/myproject"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "aws-state" {
  backend = "s3"
  config = {
    bucket = "mybucket"
    key = "terraform.tfstate"
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
    region     = "${var.AWS_REGION}"
   }
}