terraform {
  backend "s3" {
    bucket       = "dmayrant-drs-tfstate-2026"
    key          = "drs/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}