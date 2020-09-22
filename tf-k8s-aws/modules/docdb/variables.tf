variable "environment" {
  description = "The environment"
}

variable "tag_value" {
  description = "The tag for ita"
}

variable "subnet_ids" {
  type        = list
  description = "Subnet ids"
}

variable "sec_groups_ids" {
  description = "sec_groups_ids"
}


variable "vpc_id" {
  description = "The VPC id"
}

variable "instance_class" {
  description = "The instance type"
}


variable "database_name" {
  description = "The database name"
}

variable "database_username" {
  description = "The username of the database"
}

variable "database_password" {
  description = "The password of the database"
}