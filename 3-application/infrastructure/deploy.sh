#!/bin/sh
# 定义变量
REGION="ap-southeast-2"
SERVICE_NAME="springbootapp"
SERVICE_TAG="${SERVICE_TAG:-latest}"
AWS_ACCOUNT_ID="114764874165"
ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${SERVICE_NAME}"

# Docker Hub 上的 Spring Boot 镜像
DOCKER_HUB_IMAGE="springio/gs-spring-boot-docker"

# 没有需要构建的步骤，因为我们使用的是现成的 Docker 镜像

if [ "$1" = "dockerize" ];then
    # 登录到 AWS ECR
    pwd
    aws ecr get-login-password --region ${REGION} \
    | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

    # 拉取 Docker Hub 上的镜像
    docker pull ${DOCKER_HUB_IMAGE}

    # 标记镜像以便上传到 ECR
    docker tag ${DOCKER_HUB_IMAGE} ${ECR_REPO_URL}:${SERVICE_TAG}

    # 创建 ECR 仓库（如果尚不存在）
    aws ecr create-repository --repository-name ${SERVICE_NAME} --region ${REGION} || true

    # 推送镜像到 ECR
    docker push ${ECR_REPO_URL}:${SERVICE_TAG}
fi

if [ "$1" = "plan" ];then

    terraform init -backend-config="app-prod.config"
    terraform plan -var-file="production.tfvars" -var "docker_image_url=$ECR_REPO_URL:$SERVICE_TAG"
fi

if [ "$1" = "deploy" ];then

    # terraform init -backend-config="app-prod.config"
    terraform apply -var-file="production.tfvars" -var "docker_image_url=$ECR_REPO_URL:$SERVICE_TAG" -auto-approve
fi

if [ "$1" = "destroy" ];then

    # terraform init -backend-config="app-prod.config"
    terraform destroy -var-file="production.tfvars" -var "docker_image_url=$ECR_REPO_URL:$SERVICE_TAG" -auto-approve
fi
