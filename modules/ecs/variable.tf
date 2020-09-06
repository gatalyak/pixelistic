variable "environment" {
  description = "The environment"
}

variable "tag_value" {
  description = "The tag for ita"
}

variable "region" {
  description = "The region to create resources"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "availability_zones" {
  type        = list
  description = "The azs to use"
}

variable "security_groups_ids" {
  type        = list
  description = "The SGs to use"
}

variable "subnets_ids" {
  type        = list
  description = "The private subnets to use"
}

variable "public_subnet_ids" {
  type        = list
  description = "The private subnets to use"
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

variable "MONGO_DB" {
  description = "The connection string to the DB"
}

variable "FRONT_URL" {
  description = "The URL to the frontend"
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
