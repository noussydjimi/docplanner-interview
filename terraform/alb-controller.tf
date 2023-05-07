#### Resources: https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller

module "aws_load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.17.1"

  role_name = var.alb-controller-role-name

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}



resource "helm_release" "aws_load_balancer_controller" {
  name = var.alb-controller-release-name

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = var.alb-controller-release-namespace
  version    = var.alb-controller-helmchart-version

  set {
    name  = "replicaCount"
    value = var.alb-controller-replica
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = var.alb-controller-role-name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.aws_load_balancer_controller_irsa_role.iam_role_arn
  }
}
