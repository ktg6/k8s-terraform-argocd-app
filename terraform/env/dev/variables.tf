variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS CLI's profile"
}

variable "app_name" {
  type    = string
  default = "k8s-terraform-smaple"
}

variable "azs" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [80, 443]
}

variable "domain" {}