resource "aws_lb" "sample_alb" {
  name               = "eks-sample-elb"
  internal           = false
  load_balancer_type = "application"
  # security_groups    = [aws_security_group.lb_example.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "sample_alb" {
  load_balancer_arn = aws_lb.sample_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample_alb_tg.arn
  }
}

resource "aws_lb_target_group" "sample_alb_tg" {
  name     = "eks-sample-tg"
  port     = 30001
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}
