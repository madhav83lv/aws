#ecr.tf

resource "aws_ecr_repository" "myapp" {
  name = "myapp"
}

#output.tf

output "myapp-repository-URL" {
  value = aws_ecr_repository.myapp.repository_url
}

#docker build -t myapp-repository-url/myapp .
#aws ecr get-login
#docker push myapp-repository-url/myapp

