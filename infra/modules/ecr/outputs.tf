output "repository_urls" {
  description = "The URIs of the ECR repositories."
  value       = {
    for name, repo in aws_ecr_repository.this :
    name => repo.repository_url
  }
}

output "repository_arns" {
  description = "The ARNs of the ECR repositories."
  value       = {
    for name, repo in aws_ecr_repository.this :
    name => repo.arn
  }
}

output "github_actions_ecr_push_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions to push images to ECR."
  value       = aws_iam_role.github_actions_ecr_push.arn
}