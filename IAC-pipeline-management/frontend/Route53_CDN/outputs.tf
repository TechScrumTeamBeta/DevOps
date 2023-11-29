output "route53_zone_id" {
  value = aws_route53_zone.my_domain_zone.zone_id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.my_cdn_distribution.id
}
