provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

data "aws_vpc" "default_vpc" {
  id = var.vpc_id
}

data "aws_subnet" "default_subnut" {
  count = length(var.subnet_ids)
  id    = var.subnet_ids[count.index]
}

data "aws_security_group" "default_SG" {
  id = var.security_group_id
}
