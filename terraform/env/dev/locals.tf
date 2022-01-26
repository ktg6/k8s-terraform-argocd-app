locals {
  cluster_name    = "eks-sample-clustar"
  cluster_version = "1.20"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  domain              = "*.aws-intro-sample-ktg.link"
#   vpc_id          = network.vpc_id
}
