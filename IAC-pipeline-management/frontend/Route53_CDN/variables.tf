variable "my_aws_region" {
  description = "AWS region"
  default     = "ap-southeast-2"  # Replace with your desired default region
}

variable "my_domain_name" {
  description = "Domain name to be used"
  default     = "DevOps"
}

variable "my_application_origin_domain" {
  description = "Application's origin domain"
  default     = "www.example.com"  # Replace with your application's origin domain
}
