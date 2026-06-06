variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "The AWS CLI profile to use for authentication"
  default     = "default"
}

variable "project_name" {
  type        = string
  description = "The name of the project for tagging resources"
  default     = "aws-k8s-project"
}

variable "owner_name" {
  type        = string
  description = "The name of the owner for tagging resources"
  default     = "tony"
}

variable "environment" {
  type        = string
  description = "The environment name for tagging resources"
  default     = "dev"
}

variable "tfstate_bucket" {
  type        = string
  description = "The name of the S3 bucket to store Terraform state"
}