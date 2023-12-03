variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-2"
}


variable "jenkins_bucket_name" {
  description = "Name for Jenkins S3 bucket"
  default     = "techscrumbucket"
}

variable "jenkins_bucket_acl" {
  description = "Access control level for Jenkins S3 bucket"
  default     = "private"
}

