variable "project_name" {
  description = "The name of the project."
  type        = string
}
variable "environment" {
  description = "The environment (e.g., dev, staging, prod)."
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed."
  type        = string
}
variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EKS cluster."
  type        = list(string)
}
variable "node_instance_types" {
  description = "A list of EC2 instance types for the EKS worker nodes."
  type        = list(string)
  default     = ["m7i-flex.large"]
}
variable "node_desired_capacity" {
  description = "The desired number of worker nodes in the EKS node group."
  type        = number
  default     = 1
}
variable "node_max_size" {
  description = "The maximum number of worker nodes in the EKS node group."
  type        = number
  default     = 2
}
variable "node_min_size" {
  description = "The minimum number of worker nodes in the EKS node group."
  type        = number
  default     = 1
}