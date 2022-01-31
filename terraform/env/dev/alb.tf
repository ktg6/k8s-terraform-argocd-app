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

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.sample_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = 

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}

resource "aws_lb_target_group" "sample_alb_tg" {
  name     = "eks-sample-tg"
  port     = 30001
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}
