data "aws_availability_zones" "available" {}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "3.11.3"
  name            = "k8s-terraform-smaple-vpc"
  cidr            = var.vpc_cidr
  azs             = data.aws_availability_zones.available.names
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}

## -----------不使用-----------

# resource "aws_vpc" "default" {
#   cidr_block = var.vpc_cidr
#   tags = {
#     Name = var.app_name
#   }
# }

# resource "aws_subnet" "public" {
#   count                   = length(var.public_subnet_cidrs)
#   vpc_id                  = module.vpc.vpc_id
#   availability_zone       = var.azs[count.index]
#   cidr_block              = var.public_subnet_cidrs[count.index]
#   map_public_ip_on_launch = true
#   tags = merge(
#     tomap({
#       ResourceType = "subnet",
#       Identifier   = "public-${count.index + 1}",
#       Name         = "subnet-public-${count.index + 1}"
#     })
#   )
# }

# resource "aws_subnet" "private" {
#   count             = length(var.private_subnet_cidrs)
#   vpc_id            = module.vpc.vpc_id
#   availability_zone = var.azs[count.index]
#   cidr_block        = var.private_subnet_cidrs[count.index]
#   tags = merge(
#     tomap({
#       ResourceType = "subnet",
#       Identifier   = "private-${count.index + 1}",
#       Name         = "${var.app_name}-subnet-private-${count.index + 1}"
#     })
#   )
# }

## route table
# resource "aws_route" "public" {
#   route_table_id         = module.vpc.default_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }

# resource "aws_route_table_association" "public" {
#   count          = length(var.public_subnet_cidrs)
#   subnet_id      = element(module.vpc.public_subnets, count.index)
#   route_table_id = module.vpc.default_route_table_id
# }

# resource "aws_route_table" "private" {
#   vpc_id = module.vpc.vpc_id
#   tags = {
#     Name = "${var.app_name}-private-rtb"
#   }
# }

# resource "aws_route_table_association" "private" {
#   count          = length(var.private_subnet_cidrs)
#   subnet_id      = element(module.vpc.private_subnets, count.index)
#   route_table_id = aws_route_table.private.id
# }

# ## Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = module.vpc.vpc_id
#   tags = {
#     Name = "${var.app_name}-igw"
#   }
# }
