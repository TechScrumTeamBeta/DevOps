variable "my_aws_region" {
  description = "AWS region"
  default     = "ap-southeast-2"  # Replace with your desired default region
}

variable "my_domain_name" {
  description = "Domain name to be used"
  default     = "techscrumjr11.com"
}

variable "my_subdomain_name" {
  description = "Subdomain name (if any)"
  default     = "DevOps"  # Replace with your desired subdomain name, or leave it empty for the root domain
}

variable "my_existing_bucket_name" {
  description = "Name of the existing S3 bucket"
  default     = "techscrumbucket"  # Replace with the name of your existing S3 bucket
}
