module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  subnets         = module.vpc.public_subnets

  vpc_id = module.vpc.vpc_id

  node_groups = {
    ng-1 = {
      desired_capacity        = 2
      max_capacity            = 2
      min_capacity            = 2
      instance_types          = ["t3.small"]
      launch_template_id      = aws_launch_template.eks_sample.id
      launch_template_version = aws_launch_template.eks_sample.latest_version
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "aws_launch_template" "eks_sample" {
  network_interfaces {
    security_groups = [
      module.eks.cluster_primary_security_group_id,
      aws_security_group.node_sample.id
    ]
  }
}