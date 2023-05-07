# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


# https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2009
data "aws_eks_cluster" "default" {
  name = var.cluster_name
  depends_on = [
    module.eks.eks_managed_node_groups,
  ]
}

data "aws_eks_cluster_auth" "default" {
  name = var.cluster_name
  depends_on = [
    module.eks.eks_managed_node_groups,
  ]
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  # token                  = data.aws_eks_cluster_auth.default.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
    command     = "aws"
  }
}



provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
      command     = "aws"
    }
  }
}
