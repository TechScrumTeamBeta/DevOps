output "ecr_repository_url" {
  value = aws_ecr_repository.techscrum_backend_ecr.repository_url
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.techscrum_ecs_cluster.id
}

output "ecs_service_name" {
  value = aws_ecs_service.techscrum_ecs_service.name
}




