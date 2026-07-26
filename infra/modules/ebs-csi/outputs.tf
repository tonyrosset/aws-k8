output "iam_role_arn" {
  description = "IAM role ARN used by the EBS CSI controller."
  value       = aws_iam_role.main.arn
}

output "addon_name" {
  description = "Name of the installed EKS add-on."
  value       = aws_eks_addon.main.addon_name
}

output "addon_version" {
  description = "Installed EBS CSI add-on version."
  value       = aws_eks_addon.main.addon_version
}