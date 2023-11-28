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
