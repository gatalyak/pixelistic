variable "region" {
  description = "Region that the instances will be created"
}

variable "s3_bucket" {
  description = "The s3_bucket"
}

/*====
environment specific variables
======*/
variable "tag_value" {
  description = "The tag for ita"
}

variable "database_name" {
  description = "The database name for Production"
}


variable "environment" {
	description = "Environment for the application"
}

variable "availability_zones" {
	type = list
}


