variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
  default     = "default"
}

variable "terraform_state_bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
}

variable "project_name" {
  description = "The name of the project for tagging resources"
  type        = string
  default     = "aws-k8s-project"
}

variable "owner_name" {
  description = "The name of the owner for tagging resources"
  type        = string
  default     = "tony"
}