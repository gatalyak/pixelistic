output "repository_url" {
  value = "${aws_ecr_repository.pixelistic_terraform_web.repository_url}"
}


output "cluster_name" {
  value = "${aws_ecs_cluster.cluster.name}"
}

output "service_name" {
  value = "${aws_ecs_service.web.name}"
}

output "alb_dns_name_web" {
  value = "${aws_alb.alb_pixelistic_web.dns_name}"
}

output "alb_dns_name_api" {
  value = "${aws_alb.alb_pixelistic_api.dns_name}"
}


output "alb_zone_id_web" {
  value = "${aws_alb.alb_pixelistic_web.zone_id}"
}

output "alb_zone_id_api" {
  value = "${aws_alb.alb_pixelistic_api.zone_id}"
}



output "security_group_id" {
  value = "${aws_security_group.ecs_service.id}"
}

output "rep_web_url" {
  value = "${aws_ecr_repository.pixelistic_terraform_web.repository_url}"
}

output "rep_api_url" {
  value = "${aws_ecr_repository.pixelistic_terraform_api.repository_url}"
}
