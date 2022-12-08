/*
cat ~/.aws/credentials
cat ~/.aws/config

Terraform Workflow

terraform init ---> Create .terraform & .terraform.hcl.lock
terraform init --upgrade
terraform fmt  ---> Format the Indentation as per standard
terraform validate  ---> Check the code and parameters
terraform plan
terraform apply  ---> Create terraform.tfstate file
terraform destroy
terraform output -json
terraform init -migrate-state
terraform init -reconfigure
StatelockID is provided as Primary Key in DynamoDB Table

terragrunt run-all apply
terraform apply -auto-approve
terraform apply -var="inst_type=t3.micro" -var="inst_count=2" -auto-approve
terraform apply -var-file=ec2.tfvars
export TF_VAR_inst_type=t3.micro
export TF_VAR_inst_count=2
export TF_VAR_az_name=us-east-1c
terraform destroy -auto-approve
terraform.auto.tfvars will override the values written in terraform.tfvars

Terraform Meta Arguments

count -- To create the same resource multiple times
for_each -- To create the same resource in multiple regions
depends_on -- If one resource is depend on multiple arguments
for each and count cannot be used together
lifecycle
a. create_before_destroy
b. prevent_destroy
c. ignore_changes
provisioners & connections -- If any actions to be done on the resource after it is created.

#!/bin/bash
apt update
apt install -y nginx

Environmental Variables > terraform.tfvars > .auto.tfvars


*/
