locals {
    cluster_name    = "eks-sample-clustar"
    cluster_version = "1.20.7"
}

provider "aws" {
    region  = "ap-northeast-1"
}
