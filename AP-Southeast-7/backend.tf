### PRIMARY REGION REMOTE STATE

data "terraform_remote_state" "primary" {
  backend = "s3"

  config = {
    bucket = "dmayrant-drs-tfstate-2026"
    key    = "drs/terraform.tfstate"
    region = "us-east-1"
  }
}