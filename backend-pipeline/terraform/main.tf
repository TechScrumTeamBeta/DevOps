provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}


resource "aws_ecr_repository" "techscrum_backend_ecr" {
  name = var.ecr_repo_name
  
}

resource "aws_ecs_cluster" "techscrum_ecs_cluster" {
  name = var.ecs_cluster_name
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_task_execution_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = var.ecs_task_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_ecs_task_definition" "techscrum_task_definition" {
  family                = "techscrum_task_family"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "1024"  // Define CPU at task level
  memory                = "3072"  // Define Memory at task level
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "techscrum_container",
      image = "${aws_ecr_repository.techscrum_backend_ecr.repository_url}:${var.DOCKER_IMAGE_TAG}"
    }
  ])
}

resource "aws_ecs_service" "techscrum_ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.techscrum_ecs_cluster.id
  task_definition = aws_ecs_task_definition.techscrum_task_definition.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = ["subnet-0db55d9c6bd9536e2"] 
    security_groups = ["sg-0c972215503a0e632"] 
  }

  
}
