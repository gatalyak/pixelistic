variable "region" {
  description = "Region that the instances will be created"
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

variable "database_username" {
  description = "The username for the Production database"
}

variable "database_password" {
  description = "The user password for the Production database"
}

variable "secret_key_base" {
  description = "The Rails secret key for production"
}

variable "domain" {
  default = "The domain of your application"
}

variable "rabbit_name" {
	description = "A random environment"
}

variable "environment" {
	description = "Environment for the application"
}

variable "availability_zones" {
	type = list
}

variable "AWS_ACCESS_KEY_ID" {
  description = "The AWS_ACCESS_KEY_ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS_SECRET_ACCESS_KEY"
}

variable "AWS_REGION" {
  description = "The AWS_REGION"
}

variable "AWS_S3_BUCKET" {
  description = "The AWS_S3_BUCKET"
}

variable "EMAIL_USER" {
  description = "The EMAIL_USER"
}

variable "EMAIL_PASS" {
  description = "The EMAIL_PASS"
}



