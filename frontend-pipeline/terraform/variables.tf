variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-2"
}

variable "jenkins_master_ami" {
  description = "AMI for Jenkins Master"
  default     = "ami-0df4b2961410d4cff"
}

variable "jenkins_slave_ami" {
  description = "AMI for Jenkins Slave"
  default     = "ami-0df4b2961410d4cff"
}

variable "instance_type" {
  description = "EC2 instance type for Jenkins nodes"
  default     = "t2.large"
}

variable "subnet_id" {
  description = "List of Subnet IDs for EC2 instances"
  type        = list(string)
  default     = ["subnet-0db55d9c6bd9536e2", "subnet-0d29690fb83b55062"]
}

variable "jenkins_bucket_name" {
  description = "Name for Jenkins S3 bucket"
  default     = "techscrumbucket"
}

variable "jenkins_bucket_acl" {
  description = "Access control level for Jenkins S3 bucket"
  default     = "private"
}

variable "jenkins_bucket_versioning_enabled" {
  description = "Enable versioning for Jenkins S3 bucket"
  default     = true
}
