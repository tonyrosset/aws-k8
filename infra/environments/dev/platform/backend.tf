terraform {
  backend "s3" {
    bucket       = "tony-terraform-state-bucket"
    key          = "dev/platform/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}