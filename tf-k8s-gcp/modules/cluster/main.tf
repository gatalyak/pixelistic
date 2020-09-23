resource "google_container_cluster" "cluster" {
  name               = var.name
  location           = var.region
  min_master_version = var.kubernetes_version
  network            = var.network_name
  subnetwork         = var.nodes_subnetwork_name
  monitoring_service = var.monitoring_service
  logging_service    = var.logging_service

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_ip_range_name
    services_secondary_range_name = var.services_secondary_ip_range_name
  }

  # This is believed to apply to the default node pool, which gets created then deleted.
  initial_node_count       = 1
  remove_default_node_pool = true

  # The absence of a user and password here disables basic auth
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  network_policy {
    enabled = true
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_network_cidrs
      content {
        # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
        # which keys might be set in maps assigned here, so it has
        # produced a comprehensive set here. Consider simplifying
        # this after confirming which keys can be set in practice.

        cidr_block   = cidr_blocks.value.cidr_block
        display_name = lookup(cidr_blocks.value, "display_name", null)
      }
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_policy_start_time
    }
  }

  resource_labels = {
    kubernetescluster = var.name
  }

  lifecycle {
    # ignore changes to node_pool specifically so it doesn't
    #   try to recreate default node pool with every change
    # ignore changes to network and subnetwork so it doesn't
    #   clutter up diff with dumb changes like:
    #   projects/[name]/regions/us-central1/subnetworks/[name]" => "name"
    ignore_changes = [
      node_pool,
      network,
      subnetwork,
    ]
  }
}



#----------------------------------------------------------------------------------------------
#  CLOUD SOURCE REPOSITORY
#      - Enable API
#      - Create Repository
#----------------------------------------------------------------------------------------------

/*
resource "google_container_registry" "pixelistic_terraform_web" {
  project  = "pixelistic"
  location = "EU"
}

resource "google_container_registry" "pixelistic_terraform_api" {
  project  = "pixelistic"
  location = "EU"
}
*/


/*====
EKS cluster
======*/

/*
resource "aws_iam_role" "eks_cluster" {
  name = "${var.environment}-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    ita_group = "${var.tag_value}"
  }

}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}


resource "aws_eks_cluster" "aws_eks" {
  name = "${var.environment}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  
# Need to review
  vpc_config {
    subnet_ids = var.public_subnet_ids
    security_group_ids = var.sec_groups_ids
  }
  
  tags = {
    ita_group = "${var.tag_value}"
    Name      = "${var.environment}-eks-cluster"
  }

}


resource "aws_iam_role" "eks_nodes" {
  name = "${var.environment}-eks-node-group"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = {
    ita_group = "${var.tag_value}"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}


resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}


resource "aws_eks_node_group" "node" {  
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "${var.environment}-node"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.public_subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
*/





