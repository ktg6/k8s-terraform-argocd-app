output "vpc_id" {
  value = module.vpc.vpc_id
}

output "acm_id" {
  value = aws_acm_certificate.acm_cert.id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}
