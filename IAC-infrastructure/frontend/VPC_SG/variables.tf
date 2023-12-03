variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
  description = "The region where AWS operations will take place"
  default     = "ap-southeast-2"
}

variable "vpc_id" {
  description = "The ID of the VPC."
  default     = "vpc-0f8f989db1664729e"
}

variable "subnet_ids" {
  description = "List of Subnet IDs for default"
  type        = list(string)
  default     = ["subnet-0db55d9c6bd9536e2", "subnet-0d29690fb83b55062"]
}

variable "security_group_id" {
  description = "The ID of the Security Group."
  default     = "sg-0c972215503a0e632"
}



