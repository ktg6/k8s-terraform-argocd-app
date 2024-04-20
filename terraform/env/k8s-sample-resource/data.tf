# data "aws_route53_zone" "aws_intro_sample_ktg" {
#   name         = var.domain
#   private_zone = false
# }

data "aws_caller_identity" "current" {}
