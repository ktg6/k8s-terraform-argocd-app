resource "aws_security_group" "lb_sample_sg" {
  name   = "k8s-terraform-smaple-lb-sg"
  vpc_id = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg"
  }
}

resource "aws_security_group" "node_sample" {
  name   = "node-sample"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    security_groups = [
      aws_security_group.lb_sample_sg.id
    ]
  }
}