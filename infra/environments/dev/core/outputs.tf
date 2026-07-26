output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "node_group_name" {
  value = module.eks.node_goup_name
}

output "aws_load_balancer_controller_role_arn" {
  value = module.eks.aws_load_balancer_controller_role_arn
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "ecr_repository_arns" {
  value = module.ecr.repository_arns
}

output "github_actions_ecr_push_role_arn" {
  value = module.ecr.github_actions_ecr_push_role_arn
}

output "external_secrets_role_arn" {
  description = "IAM role ARN for External Secrets Operator."
  value       = module.external_secrets_aws.iam_role_arn
}

output "secrets_manager_secret_names" {
  description = "AWS Secrets Manager secret names."
  value       = module.external_secrets_aws.secret_names
}

output "secrets_manager_secret_arns" {
  description = "AWS Secrets Manager secret ARNs."
  value       = module.external_secrets_aws.secret_arns
}

output "ebs_csi_role_arn" {
  description = "IAM role ARN used by the EBS CSI driver."
  value       = module.ebs_csi.iam_role_arn
}

output "ebs_csi_addon_version" {
  description = "Installed EBS CSI add-on version."
  value       = module.ebs_csi.addon_version
}