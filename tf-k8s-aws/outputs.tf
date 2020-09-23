
output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "region" {
  value = var.region
}


output "rep_web_url" {
  value = module.eks.rep_web_url
}

output "rep_api_url" {
  value = module.eks.rep_api_url
}


output "docdb_constring" {
  value = module.docdb.docdb_constring
}


output "aws_s3" {
  value = module.eks.aws_s3
}

output "AWS_S3_BUCKET" {
  value = module.eks.AWS_S3_BUCKET
}


