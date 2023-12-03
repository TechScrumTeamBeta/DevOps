provider "aws" {
  region = var.my_aws_region
}

resource "aws_route53_zone" "my_domain_zone" {
  name = var.my_domain_name
}

resource "aws_route53_record" "my_app_record" {
  zone_id = aws_route53_zone.my_domain_zone.zone_id
  name    = var.my_subdomain_name != "" ? "${var.my_subdomain_name}.${var.my_domain_name}" : var.my_domain_name
  type    = "A"
  ttl     = 300
  records = []
}

data "aws_s3_bucket" "existing_bucket" {
  bucket = var.my_existing_bucket_name
}

resource "aws_cloudfront_distribution" "my_cdn_distribution" {
  origin {
    domain_name = data.aws_s3_bucket.existing_bucket.bucket_regional_domain_name
    origin_id   = "S3-${data.aws_s3_bucket.existing_bucket.id}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "S3-${data.aws_s3_bucket.existing_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}