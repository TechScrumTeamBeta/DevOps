variable "region" {
  default = "ap-southeast-2"
}

variable "remote_state_key" {}
variable "remote_state_bucket" {}
variable "ecs_service_name" {}
variable "docker_image_url" {}
variable "memory" {}
variable "docker_container_port" {}
variable "spring_profile" {}
variable "desired_task_number" {}
