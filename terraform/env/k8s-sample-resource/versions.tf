provider "aws" {
  region  = "ap-northeast-1"
  profile = var.aws_profile
}

# terraform {
#   backend "s3" {}
# }
