resource "aws_lb" "sample_alb" {
  name               = "k8s-terraform-smaple-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sample_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.sample_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

## acm_certificateが構築できるまでコメントアウト
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.sample_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate.acm_cert.arn

#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       status_code  = "200"
#       message_body = "ok"
#     }
#   }
# }

resource "aws_lb_target_group" "sample_alb_tg" {
  name     = "eks-sample-tg"
  port     = 30001
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "alb_record" {
  type    = "A"
  name    = var.domain
  zone_id = data.aws_route53_zone.aws_intro_sample_ktg.id
  alias {
    name                   = aws_lb.sample_alb.dns_name
    zone_id                = aws_lb.sample_alb.zone_id
    evaluate_target_health = true
  }
}
