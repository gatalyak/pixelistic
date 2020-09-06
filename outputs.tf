output "alb_dns_name_web" {
  value = module.ecs.alb_dns_name_web
}

output "alb_dns_name_api" {
  value = module.ecs.alb_dns_name_api
}


output "rep_web_url" {
  value = module.ecs.rep_web_url
}

output "rep_api_url" {
  value = module.ecs.rep_api_url
}

output "docdb_constring" {
  value = module.docdb.docdb_constring
}

output "aws_s3" {
  value = module.ecs.aws_s3
}


