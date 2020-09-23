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