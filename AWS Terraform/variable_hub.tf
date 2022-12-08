variable "instance_name" {
    description = "Value of the Name Tag for the EC2 Instance"
    type        = string
    default     = "AppServerInstance"
}

variable "instance_ami" {
    description = "Name/Id of the AMI to use for EC2"
    type        = string
    defdefault  = "ami-" 
}

variable "instance_type" {
    description = "Instance type to use specific resource"
    type        = string
    default     = "t2.micro" 
}

