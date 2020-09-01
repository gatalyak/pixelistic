output "docdb_address" {
  value = "${aws_docdb_cluster.service.master_username}"
}

output "db_access_sg_id" {
  value = "${aws_security_group.db_access_sg.id}"
}