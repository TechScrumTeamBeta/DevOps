provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_s3_bucket" "jenkins_bucket" {
  bucket = var.jenkins_bucket_name
}


resource "aws_s3_bucket_versioning" "jenkins_bucket_versioning" {
  bucket = aws_s3_bucket.jenkins_bucket.id

  versioning_configuration {
    status = var.jenkins_bucket_versioning_enabled ? "Enabled" : "Suspended"
}
}