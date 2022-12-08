terraform plan -out <file.tf>
terraform apply <file.tf>
rm <file.tf>
terraform destroy
terraform fmt  ----> Rewrite terraform configuration files to a format
terraform get  ----> Download and update modules
terraform graph  ---->
terraform output
terraform plan
terraform push
terraform refresh   ----> 
terraform remote   ---->
terraform show
terraform state
terraform taint
terraform validate
ssh-keygen -f mykey
ls > instance.tf  mykey mykey.pub  provider.tf  script.sh  terraform.tfvars  vars.tf

ls > instance.tf key.tf....mykey, mykey.pub
ssh-keygen -f mykey
ssh 52.52.4.31 -l ubuntu -i mykey
route -n

terraform apply -var RDS_PASSWORD=mklabs

ssh -i mykey ubuntu@<instance public ip from output>
sudo apt-get install mysql-client
mysql -u root -h <rds endpoint from outputs> -p'mklabs'
show databases;
host <rds endpoint from outputs>


