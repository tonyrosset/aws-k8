variable "repository_name" {
  description = "Name of the ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "Whether image tags are mutable or immutable."
  type        = string
  default     = "MUTABLE"
}

variable "github_repository" {
  description = "GitHub repository allowed to push images to ECR. Format: owner/repo."
  type        = string
}