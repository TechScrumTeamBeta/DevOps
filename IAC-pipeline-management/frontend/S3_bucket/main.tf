provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_s3_bucket" "jenkins_bucket" {
  bucket = var.jenkins_bucket_name
  acl    = var.jenkins_bucket_acl

  versioning {
    enabled = var.jenkins_bucket_versioning_enabled
  }
}

resource "aws_s3_bucket_policy" "jenkins_bucket_policy" {
  bucket = aws_s3_bucket.jenkins_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.jenkins_bucket.arn}/*"
      }
    ]
  })
}
