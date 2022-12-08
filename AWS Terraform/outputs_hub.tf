output "instance_id" {
    description = "Instance ID of the EC2 Instance"
    value       = aws_instance.web_app.id
    sensensitive = true 
    depends_on = [
      aws_vpc.vpc
    ]
}


output "instance_public_ip" {
    description = "Public IP of the EC2 Instance"
    value       = aws_instance.web_app.public_ip 
}

output "instance_private_ip" {
    description = "EC2 Instance Private IP"
    value = aws_instance.web.private_ip
}

output "instance_public_dns" {
    description = "EC2 Instance Private DNS"
    value = "http://${aws_instance.web.public_dns}"
    sensitive = true
}