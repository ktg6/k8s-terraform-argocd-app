locals {
  cluster_name    = "eks-sample-clustar"
  cluster_version = "1.20"
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.aws_profile
}

terraform {
  backend "s3" {}
}

