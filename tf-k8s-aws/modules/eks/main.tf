/*====
Cloudwatch Log Group
======*/
resource "aws_cloudwatch_log_group" "pixelistic_terraform" {
  name = "pixelistic_terraform"

  tags = {
    ita_group = var.tag_value
    Environment = "${var.environment}"
    Application = "pixelistic_terraform"
  }
}

/*====
S3 bucket
======*/
resource "aws_s3_bucket" "bucket_terraform" {
  bucket = var.AWS_S3_BUCKET
  acl = "public-read"
  tags = {
    ita_group = var.tag_value
    Environment = "${var.environment}"
    Name = "${var.AWS_S3_BUCKET}"
  }
}



/*====
ECR repository to store our Docker images
======*/
resource "aws_ecr_repository" "pixelistic_terraform_web" {
  name = var.rep_name_web
  tags = {
    ita_group = "${var.tag_value}"
  }
}

resource "aws_ecr_repository" "pixelistic_terraform_api" {
  name = var.rep_name_api
  tags = {
    ita_group = "${var.tag_value}"
  }
}


/*====
EKS cluster
======*/
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






