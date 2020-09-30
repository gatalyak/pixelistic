provider "softserve" {
  region = "Ukraine"
  }

provider "google" {
  #credentials = file("./creds/serviceaccount.json")
  project     = "pixelistic"
  region      = var.region
}

module "networking" {
  source          = "./modules/networking"
  // base network parameters
  network_name     = "${var.environment}-kube"
  subnetwork_name  = "${var.environment}-kube-subnet"
  region           = var.region
  // subnetwork primary and secondary CIDRS for IP aliasing
  subnetwork_range    = "10.40.0.0/16"
  subnetwork_pods     = "10.41.0.0/16"
  subnetwork_services = "10.42.0.0/16"
}


module "cluster" {
  source                           = "./modules/cluster"
  region                           = var.region
  name                             = "${var.environment}-gke"
  project                          = "pixelistic"
  network_name                     = "${var.environment}-kube"
  nodes_subnetwork_name            = module.networking.subnetwork
  kubernetes_version               = "1.16.13-gke.401"
  pods_secondary_ip_range_name     = module.networking.gke_pods_1
  services_secondary_ip_range_name = module.networking.gke_services_1
}


module "node_pool" {
  source             = "./modules/node_pool"
  name               = "${var.environment}-gke-node-pool"
  region             = module.cluster.region
  gke_cluster_name   = module.cluster.name
  machine_type       = "n1-standard-1"
  min_node_count     = "1"
  max_node_count     = "2"
  kubernetes_version = module.cluster.kubernetes_version
}
