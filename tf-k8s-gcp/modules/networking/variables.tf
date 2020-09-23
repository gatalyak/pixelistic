variable "network_name" {
  description = "the name of the network"
}

variable "subnetwork_name" {
  description = "name for the subnetwork"
}

variable "subnetwork_range" {
  description = "CIDR for subnetwork nodes"
}

variable "subnetwork_pods" {
  description = "secondary CIDR for pods"
}

variable "subnetwork_services" {
  description = "secondary CIDR for services"
}

variable "region" {
  description = "region to use"
}

variable "enable_cloud_nat" {
  # https://cloud.google.com/nat/docs/overview#ip_address_allocation
  description = "Setup Cloud NAT gateway for VPC"
  default     = false
}

variable "nat_ip_allocate_option" {
  # https://cloud.google.com/nat/docs/overview#ip_address_allocation
  description = "AUTO_ONLY or MANUAL_ONLY"
  type        = string
  default     = "AUTO_ONLY"
}

variable "cloud_nat_address_count" {
  # https://cloud.google.com/nat/docs/overview#number_of_nat_ports_and_connections
  description = "the count of external ip address to assign to the cloud-nat object"
  type        = number
  default     = 1
}

variable "cloud_nat_min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT."
  type        = number
  default     = 64
}

variable "cloud_nat_tcp_transitory_idle_timeout_sec" {
  # https://cloud.google.com/nat/docs/overview#specs-timeouts
  description = "Timeout in seconds for TCP transitory connections."
  type        = number
  default     = 30
}

variable "cloud_nat_log_config_filter" {
  description = "Specifies the desired filtering of logs on this NAT"
  default     = null
}

locals {
  ## the following locals modify resource creation behavior depending on var.nat_ip_allocate_option
  enable_cloud_nat        = var.enable_cloud_nat == true ? 1 : 0
  cloud_nat_address_count = var.nat_ip_allocate_option != "AUTO_ONLY" ? var.cloud_nat_address_count * local.enable_cloud_nat : 0
  nat_ips                 = var.nat_ip_allocate_option != "AUTO_ONLY" ? google_compute_address.ip_address.*.self_link : null
}

