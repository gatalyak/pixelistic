variable "environment" {
  description = "The environment"
}

variable "tag_value" {
  description = "The tag for ita"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "availability_zones" {
  type        = "list"
  description = "The azs to use"
}

variable "security_groups_ids" {
  type        = "list"
  description = "The SGs to use"
}

variable "subnets_ids" {
  type        = "list"
  description = "The private subnets to use"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "The private subnets to use"
}

variable "database_endpoint" {
  description = "The database endpoint"
}

variable "database_username" {
  description = "The database username"
}

variable "database_password" {
  description = "The database password"
}

variable "database_name" {
  description = "The database that the app will use"
}

variable "rep_name_web" {
  description = "The name of the repisitory web"
}

variable "rep_name_api" {
  description = "The name of the repisitory api"
}

variable "secret_key_base" {
  description = "The secret key base to use in the app"
}