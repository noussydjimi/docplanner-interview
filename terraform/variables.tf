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



############## ALB CONTROLLER VARIABLES ##############
variable "alb-controller-role-name" {
  type        = string
  description = "The eks alb controller IAM role name"
  default     = "aws-load-balancer-controller"
}

variable "alb-controller-replica" {
  type        = number
  description = "The alb controller replica count"
  default     = 1
}

variable "alb-controller-release-name" {
  type        = string
  description = "The eks alb controller helm release name"
  default     = "aws-load-balancer-controller"
}

variable "alb-controller-release-namespace" {
  type        = string
  description = "The eks alb controller helm release namespace"
  default     = "kube-system"
}

variable "alb-controller-helmchart-version" {
  type        = string
  description = "The eks alb controller helmchart version"
  default     = "1.5.2"
}


############## KARPENTER VARIABLES ##############
variable "karpenter-namspace" {
  type        = bool
  description = "Wether create or not karpenter namespace"
  default     = true
}
variable "karpenter-release-name" {
  type        = string
  description = "The karpenter helm release name"
  default     = "karpenter"
}

variable "karpenter-release-namespace" {
  type        = string
  description = "The karpenter helm release namespace"
  default     = "karpenter"
}

variable "karpenter-helmchart-version" {
  type        = string
  description = "The karpenter helmchart version"
  default     = "v0.16.3"
}

############## DOCPLANNER VARIABLES ##############
variable "docplanner_release_name" {
  type        = string
  description = "The docplanner helm release name"
  default     = "docplanner-app"
}

variable "docplanner_helmchart_version" {
  type        = string
  description = "The docplanner helmchart version"
  default     = "0.1.0"
}

##########################
## RDS MODULE VARIABLES ##
##########################

variable "rds_identifier" {
  type        = string
  description = "The rds instance identifier"
  default     = "doc-planner"
}

variable "rds_engine" {
  type        = string
  description = "The rds database engine"
  default     = "postgres"
}

variable "rds_engine_version" {
  type        = string
  description = "The rds database version"
  default     = "14"
}

variable "rds_instance_class" {
  type        = string
  description = "The rds instance class"
  default     = "db.t4g.micro"
}

variable "rds_instance_allocated_storage" {
  type        = number
  description = "The rds instance allocated storage"
  default     = 5
}

variable "rds_db_name" {
  type        = string
  description = "The rds database name"
  default     = "interview"
}

variable "rds_username" {
  type        = string
  description = "The rds database username"
  default     = "testuser"
}

variable "rds_port" {
  type        = string
  description = "The rds database port"
  default     = "5432"
}

variable "rds_parameter_group_family" {
  type        = string
  description = "The rds database parameter group family"
  default     = "postgres14"
}

variable "rds_major_engine_version" {
  type        = string
  description = "The rds database major engine version"
  default     = "14"
}

variable "rds_security_group_name" {
  type        = string
  description = "The rds security group name"
  default     = "rds"
}



##################################
## RDS BASTION MODULE VARIABLES ##
##################################


variable "rds_bastion_name" {
  type        = string
  description = "the rds bastion instance name"
  default     = "rds-bastion"
}

variable "rds_bastion_instance_type" {
  type        = string
  description = "the rds bastion instance type"
  default     = "t3.micro"
}

variable "rds_bastion_az" {
  type        = string
  description = "the rds bastion instance az"
  default     = "eu-north-1a"
}

variable "rds_bastion_spot_instance" {
  type        = bool
  description = "activate the rds bastion as a spot instance"
  default     = true
}

variable "rds_bastion_public_ip" {
  type        = bool
  description = "provide the rds bastion instancewith public ip"
  default     = true
}

variable "rds_bastion_security_group_name" {
  type        = string
  description = "the rds bastion instance type"
  default     = "rds-bastion"
}

variable "rds_bastion_ssm_role" {
  type        = string
  description = "the rds bastion ssm role name"
  default     = "rds-bastion-ssm-role"
}
