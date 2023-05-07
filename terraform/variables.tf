######################
## GLOBAL VARIABLES ##
######################

variable "aws_region" {
  type        = string
  description = "The AWS region."
  default     = "eu-north-1"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS account id."
  default     = null
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile."
  default     = "terraform-test"
}

# variable "tags" {
#   type = map
#   description = ""
#   value = {
#     Environment = "dev"
#   }
# }

##########################
## VPC MODULE VARIABLES ##
##########################

variable "vpc_name" {
  type        = string
  description = "The VPC name."
  default     = "docplanner"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "vpc_secondary_cidr" {
  type        = list(string)
  description = "The seconday CIDR block for the VPC. Pods will be allocated IP from this CIDR"
  default     = ["10.1.0.0/16", "10.2.0.0/16"]
}

variable "azs" {
  type        = list(string)
  description = "The list of vpc az"
  default     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "public_subnets" {
  type        = list(string)
  description = "The list of public subnet"
  default     = ["10.1.0.0/16", "10.2.0.0/16"]
}

variable "private_subnets" {
  type        = list(string)
  description = "The list of private subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "database_subnets" {
  type        = list(string)
  description = "The list of database subnet"
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}


##########################
## EKS MODULE VARIABLES ##
##########################

variable "cluster_name" {
  type        = string
  description = "The eks cluster name"
  default     = "docplanner"
}

variable "cluster_version" {
  type        = string
  description = "The eks cluster version"
  default     = "1.24"
}

variable "default_instance_types" {
  type        = list(string)
  description = "The eks default nodegroup instance types"
  default     = ["t3.micro"]
}

variable "cluster_instance_types" {
  type        = list(string)
  description = "The eks nodegroup instance types"
  default     = ["t3.medium"]
}

variable "cluster_capacity_type" {
  type        = string
  description = "The eks cluster nodes capacity type"
  default     = "SPOT"
}

variable "cluster_disk_size" {
  type        = number
  description = "The eks cluster nodes disk size"
  default     = 50
}

variable "cluster_min_size" {
  type        = number
  description = "The eks cluster nodegroup nodes minimum number"
  default     = 1
}

variable "cluster_max_size" {
  type        = number
  description = "The eks cluster nodegroup nodes maximum number"
  default     = 3
}

variable "cluster_desired_size" {
  type        = number
  description = "The eks cluster nodegroup nodes desired number"
  default     = 2
}
