output "docdb_address" {
  value = "${aws_docdb_cluster.service.master_username}"
}

output "db_access_sg_id" {
  value = "${aws_security_group.db_access_sg.id}"
}

output "docdb_constring" {
  value = "mongodb://${aws_docdb_cluster.service.master_username}:${aws_docdb_cluster.service.master_password}@${aws_docdb_cluster.service.endpoint}:${aws_docdb_cluster.service.port}/${var.database_name}"
}

