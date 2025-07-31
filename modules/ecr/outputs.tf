output "repository_urls" {
  description = "Map of ECR repository URLs"
  value = {
    for k, repo in aws_ecr_repository.this :
    k => repo.repository_url
  }
}
