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
