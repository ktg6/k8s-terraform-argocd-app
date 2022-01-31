# resource "aws_acm_certificate" "this" {
#   domain_name       = "*.aws-intro-sample-ktg.link"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_zone" "this" {
#   name = "aws-intro-sample-ktg.link"
#   vpc {
#     vpc_id = module.vpc.vpc_id
#   }
#   tags = merge(
#     tomap({
#       ResourceType = "route53-zone",
#       Identifier   = "aws-eks-sample-hostzone",
#       Name         = "aws-eks-sample-route53-zone"
#     })
#   )
# }

# resource "aws_route53_record" "this" {
#   depends_on = [aws_acm_certificate.this]

#   for_each = {
#     for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   zone_id = aws_route53_zone.this.zone_id
#   name    = each.value.name
#   records = [each.value.record]
#   ttl     = 60
#   type    = each.value.type
# }

# resource "aws_acm_certificate_validation" "this" {
#   certificate_arn         = aws_acm_certificate.this.arn
#   validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
# }

# data "aws_route53_zone" "this" {
#   name         = var.domain
#   private_zone = false
# }
