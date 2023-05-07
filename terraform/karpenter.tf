#### Resources: https://github.com/terraform-aws-modules/terraform-aws-eks/tree/v19.13.1/modules/karpenter

module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "= 19.3.1"

  cluster_name = module.eks.cluster_name

  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  create_iam_role = false
  iam_role_arn    = module.eks.eks_managed_node_groups["initial"].iam_role_arn

#   tags = var.tags
}


resource "helm_release" "karpenter" {
  namespace        = var.karpenter-release-name
  create_namespace = true

  name       = var.karpenter-release-namespace
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = var.karpenter-helmchart-version

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.irsa_arn
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = module.karpenter.instance_profile_name
  }

  set {
    name  = "logLevel"
    value = "debug"
  }

    set {
    name  = "controller.logLevel"
    value = "debug"
  }

  depends_on = [module.eks.eks_managed_node_groups]
}
