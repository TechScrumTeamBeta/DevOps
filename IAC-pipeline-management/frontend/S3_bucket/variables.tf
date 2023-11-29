variable "aws_access_key" {
  description = "AWS access key"
  # Define the access key value or use environment variables/other methods to retrieve it securely.
}

variable "aws_secret_key" {
  description = "AWS secret key"
  # Define the secret key value or use environment variables/other methods to retrieve it securely.
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-2"  # Set your desired default region or specify it during runtime
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
