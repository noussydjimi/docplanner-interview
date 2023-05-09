#### Resources: https://github.com/terraform-aws-modules/terraform-aws-eks/tree/v19.13.1/modules/karpenter
#### Resources: https://artifacthub.io/packages/helm/karpenter/karpenter
#### Resources: https://github.com/terraform-aws-modules/terraform-aws-iam

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "= 19.3.1"

  cluster_name = module.eks.cluster_name

  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  create_iam_role = false
  iam_role_arn    = module.eks.eks_managed_node_groups["initial"].iam_role_arn

  #   tags = var.tags
}


resource "helm_release" "karpenter" {
  namespace        = var.karpenter_release_namespace
  create_namespace = var.karpenter_namespace

  name       = var.karpenter_release_name
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = var.karpenter_helmchart_version

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


########## fix karpenter##########
module "karpenter_fix" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "KarpenterFix"
  path        = "/"
  description = "A fix for Karpenter IAM role for service account"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameter",
        "pricing:GetProducts",
        "iam:PassRole",
        "ec2:TerminateInstances",
        "ec2:RunInstances",
        "ec2:DescribeSubnets",
        "ec2:DescribeSpotPriceHistory",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeImages",
        "ec2:DeleteLaunchTemplate",
        "ec2:CreateTags",
        "ec2:CreateLaunchTemplate",
        "ec2:CreateFleet"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = module.karpenter.irsa_name
  policy_arn = module.karpenter_fix.arn
}

data "aws_security_group" "eks_cluster" {
  id = module.eks.cluster_security_group_id
}

resource "helm_release" "provisioner" {
  name    = var.provisioner_release_name
  chart   = "../k8s/provisioner"
  version = var.provisioner_helmchart_version

  set {
    name  = "securityGroupSelector"
    value = data.aws_security_group.eks_cluster.name
  }

  depends_on = [helm_release.karpenter]
}
