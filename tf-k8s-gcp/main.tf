/*====
Variables used across all modules
======*/

locals {
  availability_zones = var.availability_zones
}


provider "google" {
  credentials = file("./creds/serviceaccount.json")
  project     = "pixelistic"
  region      = var.region
}

module "networking" {
  source          = "./modules/networking"
  // base network parameters
  network_name     = "kube"
  subnetwork_name  = "kube-subnet"
  region           = var.region
  //enable_flow_logs = "false"
  // subnetwork primary and secondary CIDRS for IP aliasing
  subnetwork_range    = "10.40.0.0/16"
  subnetwork_pods     = "10.41.0.0/16"
  subnetwork_services = "10.42.0.0/16"
}


module "cluster" {
  source                           = "./modules/cluster"
  region                           = var.region
  name                             = "gke-example"
  project                          = "pixelistic"
  network_name                     = "kube"
  nodes_subnetwork_name            = module.networking.subnetwork
  kubernetes_version               = "1.16.13-gke.401"
  pods_secondary_ip_range_name     = module.networking.gke_pods_1
  services_secondary_ip_range_name = module.networking.gke_services_1
}


module "node_pool" {
  source             = "./modules/node_pool"
  name               = "gke-example-node-pool"
  region             = module.cluster.region
  gke_cluster_name   = module.cluster.name
  machine_type       = "n1-standard-4"
  min_node_count     = "1"
  max_node_count     = "2"
  kubernetes_version = module.cluster.kubernetes_version
}



/*
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
*/
/*
module "eks" {
  source             = "./modules/eks"
  environment        = var.environment
  vpc_id             = "test" //module.networking.vpc_id
  availability_zones = local.availability_zones
  region             = var.region
  rep_name_web       = "pixelistic_tf/web"
  rep_name_api       = "pixelistic_tf/api"
  public_subnet_ids  = ["10.0.1.0/24", "10.0.2.0/24"] //module.networking.public_subnets_id
  sec_groups_ids     = ["10.0.1.0/24", "10.0.2.0/24"] //concat([module.docdb.db_access_sg_id], module.networking.security_groups_ids)
  AWS_S3_BUCKET      = "${var.environment}-${var.s3_bucket}"
  tag_value         = var.tag_value
}
*/
