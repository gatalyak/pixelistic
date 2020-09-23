/*
output "repository_url" {
  value = "${aws_ecr_repository.pixelistic_terraform_web.repository_url}"
}

output "aws_s3" {
  value = "${aws_s3_bucket.bucket_terraform.bucket_regional_domain_name}"
}

output "rep_web_url" {
  value = "${aws_ecr_repository.pixelistic_terraform_web.repository_url}"
}

output "rep_api_url" {
  value = "${aws_ecr_repository.pixelistic_terraform_api.repository_url}"
}


output "eks_cluster_endpoint" {
  value = aws_eks_cluster.aws_eks.endpoint
}

output "eks_cluster_certificat_authority" {
  value = aws_eks_cluster.aws_eks.certificate_authority 
}

output "AWS_S3_BUCKET" {
  value = var.AWS_S3_BUCKET
}

output "eks_cluster_name" {
  value = "${aws_eks_cluster.aws_eks.name}"
}
*/
output "name" {
  description = "The static name of the GKE cluster"
  value       = google_container_cluster.cluster.name
}

output "endpoint" {
  description = "The GKE Cluster Endpoints IP"
  value       = google_container_cluster.cluster.endpoint
}

## This is passed back out in case it's needed to inherit for node pools
output "kubernetes_version" {
  description = "The Kubernetes version used when creating or upgrading this cluster. This does not reflect the current version of master or worker nodes."
  value       = var.kubernetes_version
}

output "master_version" {
  description = "The current version of the Kubernetes master nodes, which will differ from the kubernetes_version output if GKE upgrades masters automatically."
  value       = google_container_cluster.cluster.master_version
}

output "region" {
  description = "The region in which this cluster exists"
  value       = var.region
}
