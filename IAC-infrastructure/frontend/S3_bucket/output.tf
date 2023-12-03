output "jenkins_bucket_arn" {
  description = "The ARN of the Jenkins S3 bucket"
  value       = aws_s3_bucket.jenkins_bucket.arn
}
