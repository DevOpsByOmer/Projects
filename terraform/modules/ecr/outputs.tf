output "repo_urls" {
  description = "ECR repository URLs"
  value = {
    for repo in aws_ecr_repository.this :
    repo.name => repo.repository_url
  }
}
