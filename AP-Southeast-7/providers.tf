provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "dr"
  region = "ap-southeast-7"
}