provider "aws" {
  region = "my_aws_region"
}

resource "aws_route53_zone" "my_domain_zone" {
  name = "techscrumjr11.com"
}

resource "aws_route53_record" "my_app_record" {
  zone_id = aws_route53_zone.my_domain_zone.zone_id
  name    = "DevOps"  # Replace with your domain name
  type    = "A"            # Example record type, modify as needed
  ttl     = "300"
  records = ["1.2.3.4"]    # Replace with the IP address of your application
}

resource "aws_cloudfront_distribution" "my_cdn_distribution" {
  origin {
    domain_name = "techscrumjr11.com"  # Replace with your application's origin domain (e.g., example.com)
    origin_id   = "my-app-origin"  # Unique identifier for the origin
  }

  # Define other CloudFront configuration settings as needed
  # For example: caching behavior, SSL settings, viewer protocol policy, etc.
  # See Terraform AWS CloudFront provider documentation for available configurations
}
