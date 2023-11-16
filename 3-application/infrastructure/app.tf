provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}
# In the configuration, I'm going to first pass in the key as and 
# let's just also create a variable for that var dot remote state key, all right?
data "terraform_remote_state" "platform" {
  backend = "s3"

  config = {
    key     = var.remote_state_key
    bucket  = var.remote_state_bucket
    region  = var.region
  }
}
# 47. Creating ECS Task Definition 使用json file 来定义ecs task
data "template_file" "ecs_task_definition_template" {
  template = file("task_definition.json")

  vars = {
    task_definition_name  = var.ecs_service_name
    ecs_service_name      = var.ecs_service_name
    docker_image_url      = var.docker_image_url
    memory                = var.memory
    docker_container_port = var.docker_container_port
    spring_profile        = var.spring_profile
    region                = var.region
  }
}

# resource "aws_ecs_task_definition" "springbootapp-task-definition" {
#   container_definitions     = data.template_file.ecs_task_definition_template.rendered
#   family                    = var.ecs_service_name
#   cpu                       = 512
#   memory                    = var.memory
#   requires_compatibilities  = ["FARGATE"]
#   network_mode              = "awsvpc"
#   execution_role_arn        = aws_iam_role.fargate_iam_role.arn
#   task_role_arn             = aws_iam_role.fargate_iam_role.arn
# }
resource "aws_ecs_task_definition" "springbootapp-task-definition" {
  family                   = var.ecs_service_name
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.fargate_iam_role.arn
  task_role_arn            = aws_iam_role.fargate_iam_role.arn
  cpu                      = "512"
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = var.ecs_service_name
      image     = var.docker_image_url
      essential = true
      environment = [
        {
          name  = "spring_profiles_active"
          value = var.spring_profile
        }
      ]
      portMappings = [
        {
          containerPort = var.docker_container_port
          hostPort      = var.docker_container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${var.ecs_service_name}-LogGroup"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# So these roles are going to allow me to have my fargate task execute proper
#  to reach other.Services.
# So to provide that functionality, 
# to have those roles created, I'll be seeing you on the next video.

resource "aws_iam_role" "fargate_iam_role" {
  name = "${var.ecs_service_name}-IAM-Role"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
 {
   "Effect": "Allow",
   "Principal": {
     "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
   },
   "Action": "sts:AssumeRole"
  }
  ]
 }
EOF
}

resource "aws_iam_role_policy" "fargate_iam_policy" {
  name = "${var.ecs_service_name}-IAM-Role"
  role = aws_iam_role.fargate_iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ecr:*",
        "logs:*",
        "cloudwatch:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}



# 50. Creating Security Group for ECS Service
resource "aws_security_group" "app_security_group" {
  name        = "${var.ecs_service_name}-SG"
  description = "Security group for springbootapp to communicate in and out"
  vpc_id      = data.terraform_remote_state.platform.outputs.vpc_id
# 代表本vpc的都可以访问这个application
  ingress {
    from_port   = 8080
    protocol    = "TCP"
    to_port     = 8080
    cidr_blocks = [data.terraform_remote_state.platform.outputs.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
# So basically I'm going to allow my application to go out to the Internet 
# freely without any limitations
# protocol = "-1" 表示这个规则适用于所有协议。
# of ports or protocols.
  tags = {
    Name = "${var.ecs_service_name}-SG"
  }
}

# 51. Creating ALB Target Group for ECS Service
# 创建target group 到ecs
resource "aws_alb_target_group" "ecs_app_target_group" {
  name        = "${var.ecs_service_name}-TG"
  port        = var.docker_container_port
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.platform.outputs.vpc_id
  target_type = "ip"
# 原来healthcheck 在 targetgroup 里面吗？
  health_check {
    path                = "/actuator/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "60"
    timeout             = "30"
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }

  tags = {
    Name = "${var.ecs_service_name}-TG"
  }
}

# 52. Creating ECS Service 设置fargate 在哪个 subnets中在ecs 中设置。
resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  # task_definition = "${aws_ecs_task_definition.springbootapp-task-definition.family}:${aws_ecs_task_definition.springbootapp-task-definition.revision}"
  # task_definition = var.ecs_service_name 我看例子都是arn
  task_definition = "${aws_ecs_task_definition.springbootapp-task-definition.family}:${aws_ecs_task_definition.springbootapp-task-definition.revision}"
  desired_count   = var.desired_task_number
  cluster         = data.terraform_remote_state.platform.outputs.ecs_cluster_name
  launch_type     = "FARGATE"

  network_configuration {
    # subnets           = [data.terraform_remote_state.platform.outputs.ecs_public_subnets]
    subnets           = data.terraform_remote_state.platform.outputs.ecs_public_subnets
    security_groups   = [aws_security_group.app_security_group.id]
    assign_public_ip  = true
  }

  load_balancer {
    container_name   = var.ecs_service_name
    container_port   = var.docker_container_port
    target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
  }
}
# 53. Creating ALB Listener Rule for ECS Service
resource "aws_alb_listener_rule" "ecs_alb_listener_rule" {
  listener_arn = data.terraform_remote_state.platform.outputs.ecs_alb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
  }

  condition {
    host_header {
      values = ["${lower(var.ecs_service_name)}.${data.terraform_remote_state.platform.outputs.ecs_domain_name}"]
    }
  }
}

resource "aws_cloudwatch_log_group" "springbootapp_log_group" {
  name = "${var.ecs_service_name}-LogGroup"
}