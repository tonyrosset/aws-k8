output "secret_names" {
  description = "AWS Secrets Manager secret names by input key."

  value = {
    for key, secret in aws_secretsmanager_secret.main :
    key => secret.name
  }
}

output "secret_arns" {
  description = "AWS Secrets Manager secret ARNs by input key."

  value = {
    for key, secret in aws_secretsmanager_secret.main :
    key => secret.arn
  }
}

output "iam_role_arn" {
  description = "IAM role ARN used by External Secrets Operator."
  value       = aws_iam_role.main.arn
}