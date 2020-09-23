#######################
# Create the network and subnetworks, including secondary IP ranges on subnetworks
#######################

resource "google_compute_network" "network" {
  name                    = var.network_name
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

/* note that for secondary ranges necessary for GKE Alias IPs, the ranges have
 to be manually specified with terraform currently -- no GKE automagic allowed here. */
resource "google_compute_subnetwork" "subnetwork" {
  name                     = var.subnetwork_name
  ip_cidr_range            = var.subnetwork_range
  network                  = google_compute_network.network.self_link
  region                   = var.region
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "gke-pods-1"
    ip_cidr_range = var.subnetwork_pods
  }

  secondary_ip_range {
    range_name    = "gke-services-1"
    ip_cidr_range = var.subnetwork_services
  }

  /* We ignore changes on secondary_ip_range because terraform doesn't list
    them in the same order every time during runs. */
  lifecycle {
    ignore_changes = [secondary_ip_range]
  }
}

resource "google_compute_router" "router" {
  count   = local.enable_cloud_nat
  name    = var.network_name
  network = google_compute_network.network.name
  region  = var.region
}

resource "google_compute_address" "ip_address" {
  count  = local.cloud_nat_address_count
  name   = "nat-external-address-${count.index}"
  region = var.region
}

resource "google_compute_router_nat" "nat_router" {
  count                              = local.enable_cloud_nat
  name                               = var.network_name
  router                             = google_compute_router.router.0.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = local.nat_ips
  min_ports_per_vm                   = var.cloud_nat_min_ports_per_vm
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  tcp_transitory_idle_timeout_sec    = var.cloud_nat_tcp_transitory_idle_timeout_sec

  log_config {
    enable = var.cloud_nat_log_config_filter == null ? false : true
    filter = var.cloud_nat_log_config_filter == null ? "ALL" : var.cloud_nat_log_config_filter
  }
}


/*====
The VPC
======*/
/*
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-vpc"
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${var.environment}-eks-cluster" = "shared"
  }
}
*/

/*====
The VPC EndPoint
======*/
/*
resource "aws_vpc_endpoint" "private-s3" {
    vpc_id = aws_vpc.vpc.id
    service_name = "com.amazonaws.${var.region}.s3"
    route_table_ids = ["${aws_route_table.private.id}"]
    policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ],
"Version": "2008-10-17"
}
POLICY

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-vpc-ep"
    Environment = "${var.environment}"
  }

}

*/

/*====
Subnets
======*/

/* Internet gateway for the public subnet */
/*
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-igw"
    Environment = "${var.environment}"
  }
}
*/

/* Elastic IP for NAT */
/*
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [ aws_internet_gateway.ig ]

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-nat-eip-eip"
    Environment = "${var.environment}"
  }


}
*/
/* NAT */
/*
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [ aws_internet_gateway.ig ]

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-${element(var.availability_zones, 1)}-nat"
    Environment = "${var.environment}"
  }
}
*/

/* Public subnet */
/*
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = "${var.environment}"
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/${var.environment}-eks-cluster" = "shared"
  }
}
*/
/* Private subnet */
/*
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.environment}"
  }
}
*/
/* Routing table for private subnet */
/*
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}
*/
/* Routing table for public subnet */
/*
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id

}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id

}
*/
/* Route table associations */
/*
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "private" {
  count           = length(var.private_subnets_cidr)
  subnet_id       = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id  = aws_route_table.private.id

}
*/

/*====
VPC's Default Security Group
======*/
/*
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [ aws_vpc.vpc ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    ita_group = "${var.tag_value}"
    Environment = "${var.environment}"
  }
}
*/