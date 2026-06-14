output "repository_name" {
  description = "The name of the ECR repository."
  value       = aws_ecr_repository.this.name  
}

output "repository_url" {
  description = "The URI of the ECR repository."
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "The ARN of the ECR repository."
  value       = aws_ecr_repository.this.arn
}

output "github_actions_ecr_push_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions to push images to ECR."
  value       = aws_iam_role.github_actions_ecr_push.arn
}