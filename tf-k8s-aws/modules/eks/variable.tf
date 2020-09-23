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


variable "sec_groups_ids" {
  type        = list
  description = "The web SGs to use"
}


variable "public_subnet_ids" {
  type        = list
  description = "The public subnets to use"
}


variable "rep_name_web" {
  description = "The name of the repisitory web"
}

variable "rep_name_api" {
  description = "The name of the repisitory api"
}


variable "AWS_S3_BUCKET" {
  description = "The AWS_S3_BUCKET"
}
