
variable "image_tag_mutability" {
  description = "Whether image tags are mutable or immutable."
  type        = string
  default     = "MUTABLE"
}

variable "github_repository" {
  description = "GitHub repository allowed to push images to ECR. Format: owner/repo."
  type        = string
}

variable "repositories" {
  description = "List of ECR repositories to create."
  type        = list(string)
}

variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string
}