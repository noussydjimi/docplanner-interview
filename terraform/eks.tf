#### Resources: https://github.com/terraform-aws-modules/terraform-aws-eks

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "= 19.13.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = var.default_instance_types
    iam_role_attach_cni_policy = true
  }

  eks_managed_node_groups = {
    initial = {
      min_size     = var.cluster_min_size
      max_size     = var.cluster_max_size
      desired_size = var.cluster_desired_size

      instance_types = var.cluster_instance_types
      capacity_type  = var.cluster_capacity_type
      disk_size = var.cluster_disk_size
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true


  # tags = var.tags
}
