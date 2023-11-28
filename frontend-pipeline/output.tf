output "jenkins_master_instance_id" {
  description = "The instance ID of the Jenkins Master node"
  value       = aws_instance.jenkins_master.id
}

output "jenkins_master_public_ip" {
  description = "The public IP of the Jenkins Master node"
  value       = aws_instance.jenkins_master.public_ip
}

output "jenkins_slave_instance_id" {
  description = "The instance ID of the Jenkins Slave node"
  value       = aws_instance.jenkins_slave.id
}

output "jenkins_slave_public_ip" {
  description = "The public IP of the Jenkins Slave node"
  value       = aws_instance.jenkins_slave.public_ip
}

output "jenkins_bucket_arn" {
  description = "The ARN of the Jenkins S3 bucket"
  value       = aws_s3_bucket.jenkins_bucket.arn
}
