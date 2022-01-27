variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS CLI's profile"
}

variable "domain" {}

variable "app_name" {
  type    = string
  default = "eks-terraform-sample"
}

variable "azs" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "public_subnet_cidrs" {}

variable "private_subnet_cidrs" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
