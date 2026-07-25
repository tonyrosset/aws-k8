module "vpc" {
  source = "../../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr

  public_subnet_cidrs = [
    "10.20.1.0/24",
    "10.20.2.0/24"
  ]
  private_subnet_cidrs = [
    "10.20.11.0/24",
    "10.20.12.0/24"
  ]
  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]
}

module "eks" {
  source = "../../../modules/eks"

  project_name = var.project_name
  environment  = var.environment

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.public_subnet_ids #change to private_subnet_ids after testing

  node_instance_types   = ["m7i-flex.large"]
  node_desired_capacity = 1
  node_max_size         = 2
  node_min_size         = 1
}

module "ecr" {
  source            = "../../../modules/ecr"
  project_name      = var.project_name
  github_repository = var.github_repository
  repositories = [
    "${var.project_name}-${var.environment}-python-template"
  ]
}

module "external_secrets_aws" {
  source = "../../../modules/secrets-manager"

  project_name = var.project_name
  environment  = var.environment

  secret_names = [
    "python-template"
  ]

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
}