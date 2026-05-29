module "vpc" {
  source = "../../modules/vpc"

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
