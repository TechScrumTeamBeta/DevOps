terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region = "ap-southeast-2"
}

resource "aws_ecs_cluster" "your_cluster" {
  name = "your-ecs-cluster-name"
}

resource "aws_ecs_task_definition" "your_task_definition" {
  family                   = "your-task-family"
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  
  container_definitions = jsonencode([
    {
      name      = "your-container-name"
      image     = "your-docker-image-url"
      cpu       = 256
      memory    = 512
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 3000,
        },
      ],
      essential = trues
    }
  ])
}

resource "aws_ecs_service" "your_service" {
  name            = "your-ecs-service"
  cluster         = "your-ecs-cluster-name"
  task_definition = aws_ecs_task_definition.your_task_definition.arn
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets = ["your-subnet-id"]
    security_groups = ["your-security-group-id"]
  }

}
