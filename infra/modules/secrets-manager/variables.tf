variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name, such as dev or prod."
  type        = string
}

variable "secret_names" {
  description = "Names of the AWS Secrets Manager secret containers to create."
  type        = set(string)
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS IAM OIDC provider."
  type        = string
}

variable "oidc_provider_url" {
  description = "EKS OIDC provider URL without the https:// prefix."
  type        = string
}

variable "service_account_namespace" {
  description = "Namespace containing the External Secrets ServiceAccount."
  type        = string
  default     = "external-secrets"
}

variable "service_account_name" {
  description = "Name of the External Secrets ServiceAccount."
  type        = string
  default     = "external-secrets"
}