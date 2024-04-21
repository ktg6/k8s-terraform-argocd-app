variable "profile" {
  type        = string
  default     = "default"
  description = "AWS CLI's profile"
}

variable "region" {
  description = "AWS region to create resources"
  default     = "ap-northeast-1"
}

variable "vpc_id" {
  type        = string
  description = "Target VPC ID"
}

variable "subnet_id_1" {
  type        = string
  description = "Target Subnet ID 1"
}

variable "subnet_id_2" {
  type        = string
  description = "Target Subnet ID 2"
}

variable "ouid" {
  type        = string
  description = "AWS OUID"
}
