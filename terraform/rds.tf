#### Resources: https://github.com/terraform-aws-modules/terraform-aws-rds
#### Resources: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
#### Resources: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "= 5.9.0"

  identifier = var.rds_identifier

  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_instance_allocated_storage

  db_name  = var.rds_db_name
  username = var.rds_username
  port     = var.rds_port
  create_random_password = true

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["${aws_security_group.rds.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  create_monitoring_role = false

  # tags = var.tags

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets

  # DB parameter group
  family = var.rds_parameter_group_family

  # DB option group
  major_engine_version = var.rds_major_engine_version

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "autovacuum"
      value = "1"
    },
    {
      name = "client_encoding"
      value = "utf8"
    }
  ]
}


data "aws_ami" "bastion-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "= v5.0.0"

  name = var.rds_bastion_name

  ami                    = data.aws_ami.bastion-ami.id
  instance_type          = var.rds_bastion_instance_type
  monitoring             = false
  availability_zone      = var.rds_bastion_az
  vpc_security_group_ids = ["${aws_security_group.rds_bastion.id}"]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = var.rds_bastion_public_ip

  create_spot_instance = var.rds_bastion_spot_instance

  iam_role_name = module.iam_assumable_role.iam_role_name
  iam_instance_profile = module.iam_assumable_role.iam_instance_profile_name
  iam_role_path = module.iam_assumable_role.iam_role_path

  # tags = var.tags
}




resource "aws_security_group" "rds" {
  name        = var.rds_security_group_name
  description = "rds"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_security_group_rule" "rds-eks" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.rds.id
  source_security_group_id = module.eks.cluster_security_group_id
}

resource "aws_security_group_rule" "rds_bastion" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "-1"
  security_group_id = aws_security_group.rds.id
  source_security_group_id = aws_security_group.rds_bastion.id
}

resource "aws_security_group" "rds_bastion" {
  name        = var.rds_bastion_security_group_name
  description = "rds-bastion"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "rds-bastion-sg"
  }
}


resource "aws_security_group_rule" "bastion" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.rds_bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.rds_bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
}


module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "= v5.18.0"

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  create_role = true
  create_instance_profile = true

  role_name         = var.rds_bastion_ssm_role
  role_requires_mfa = false

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  number_of_custom_role_policy_arns = 1
}
