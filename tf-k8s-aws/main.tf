/*====
Variables used across all modules
======*/
locals {
  availability_zones = var.availability_zones
}

provider "aws" {
  region = var.region
  access_key = ""
  secret_key = ""
}


module "networking" {
  source               = "./modules/networking"
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
  region               = var.region
  availability_zones   = local.availability_zones
  tag_value            = var.tag_value
}



module "docdb" {
  source            = "./modules/docdb"
  environment       = var.environment
  database_name     = var.database_name
  database_username = var.database_username
  database_password = var.database_password
  subnet_ids        = module.networking.private_subnets_id
  vpc_id            = module.networking.vpc_id
  vpc_cidr          = module.networking.vpc_cidr
  instance_class    = "db.t3.medium"
  tag_value         = var.tag_value
}



module "eks" {
  source             = "./modules/eks"
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  availability_zones = local.availability_zones
  region             = var.region
  rep_name_web       = "pixelistic_tf/web"
  rep_name_api       = "pixelistic_tf/api"
  public_subnet_ids  = module.networking.public_subnets_id
  sec_groups_ids     = concat([module.docdb.db_access_sg_id], module.networking.security_groups_ids)
  AWS_S3_BUCKET      = "${var.environment}-${var.s3_bucket}"
  tag_value         = var.tag_value
}

