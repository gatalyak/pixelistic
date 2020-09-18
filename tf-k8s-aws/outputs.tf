/*
output "alb_dns_name_web" {
  value = module.eks.alb_dns_name_web
}

output "alb_dns_name_api" {
  value = module.eks.alb_dns_name_api
}
*/

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


