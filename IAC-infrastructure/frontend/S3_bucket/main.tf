provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_s3_bucket" "jenkins_bucket" {
  bucket = var.jenkins_bucket_name
}

resource "aws_s3_bucket_acl" "jenkins_bucket_acl" {
  bucket = aws_s3_bucket.jenkins_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "jenkins_bucket_versioning" {
  bucket = aws_s3_bucket.jenkins_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "jenkins_bucket_policy" {
  bucket = aws_s3_bucket.jenkins_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.jenkins_bucket.arn}/*"
      }
    ]
  })
}
