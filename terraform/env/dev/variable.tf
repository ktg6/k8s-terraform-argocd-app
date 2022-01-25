variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS CLI's profile"
}

variable "app_name" {
  type    = string
  default = "eks-terraform-sample"
}

variable "domain" {}