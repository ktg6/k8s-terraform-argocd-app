resource "aws_acm_certificate" "acm_cert" {
  domain_name               = "aws-intro-sample-ktg.link"
  subject_alternative_names = ["*.aws-intro-sample-ktg.link"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_cert_validation" {
  for_each        = { for el in aws_acm_certificate.acm_cert.domain_validation_options : el.domain_name => el }
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.aws_intro_sample_ktg.id
  name            = each.value.resource_record_name
  type            = each.value.resource_record_type
  records         = [each.value.resource_record_value]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "acm_cert_validation" {
  certificate_arn         = aws_acm_certificate.acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_cert_validation : record.fqdn]
  timeouts {
    create = "2m"
  }
}
