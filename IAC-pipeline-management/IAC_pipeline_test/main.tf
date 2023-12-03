provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_ecr_repository" "new_repository" {
  name                 = "test-app-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
