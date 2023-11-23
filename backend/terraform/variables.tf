variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "ap-southeast-2"
}

variable "ecr_repo_name" {
  default = "techscrum_backend_ecr"
}

variable "ecs_cluster_name" {
  default = "techscrum_ecs_cluster"
}

variable "ecs_service_name" {
  default = "techscrum_ecs_service"
}

variable "DOCKER_IMAGE_TAG" {
  default = "latest"
}

variable "ecs_task_execution_role_name" {
  description = "The name of the ECS task execution role"
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "ecs_task_role_name" {
  description = "The name of the ECS task role"
  type        = string
  default     = "ecsTaskRole"
}

// Define other variables as needed
