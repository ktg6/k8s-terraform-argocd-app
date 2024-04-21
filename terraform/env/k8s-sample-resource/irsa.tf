module "eks_irsa" {
    source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
    version                       = "3.6.0"
    create_role                   = true
    role_name                     = "eks-irsa"
    provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
    role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
    oidc_fully_qualified_subjects = ["system:serviceaccount:default:eks-irsa"]
}

resource "kubernetes_service_account" "eks_irsa" {
    metadata {
        name        = "eks-irsa"
        namespace   = "default"
        annotations = {
            "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-irsa"
        }
    }
    automount_service_account_token = true
}
