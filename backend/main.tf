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

resource "aws_ecs_cluster" "techScrumCluster" {
  name = "techScrumCluster"
}

resource "aws_ecs_task_definition" "techScrum-dev" {
  family                   = "techScrum-dev"
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  
  container_definitions = jsonencode([
    {
      name      = "techscrum-be"
      image     = "650635451238.dkr.ecr.us-east-1.amazonaws.com/techscrum-be"
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

resource "aws_ecs_service" "techScrumBackend" {
  name            = "techScrumBackend"
  cluster         = "techScrumCluster"
  task_definition = aws_ecs_task_definition.your_task_definition.arn
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets = ["your-subnet-id"]
    security_groups = ["your-security-group-id"]
  }

}
