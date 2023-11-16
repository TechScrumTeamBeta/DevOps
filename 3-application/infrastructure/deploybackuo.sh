#!/bin/sh
# 定义变量 define variable
REGION="ap-southeast-2"
SERVICE_NAME="springbootapp"
SERVICE_TAG="${SERVICE_TAG}"
AWS_ACCOUNT_ID="114764874165"
ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${SERVICE_NAME}"
#  I'm going to create a skeleton for our pipeline

# stages. 创建pipeline 框架
#Using the Maven commands right here.
# use the Maven command just m v n instead of mvn v.
#  And then what I'm going to do basically is go back one directory because we're in the infrastructure
if [ "$1" = "build" ];then 
    cd ..
    
    sh mvnw clean install
elif [ "$1" = "test" ];then
    echo $SERVICE_NAME
    find ../target/ -type f \( -name "*.jar" -not -name "*sources.jar" \) -exec cp {} ../infrastructure/$SERVICE_NAME.jar \;
# 
# Now it's time to move on to our Dockerized stage.

# And in this stage we're going to first locate the jar file that we built on the previous stage as the

# build stage with Maven.

# And then we're going to log into AWS, ECR, and we're going to tag, build and push our Docker image

# So I'll start with my find command.

# And the first thing I'm going to do is to go to target the dot, dot slash target to go one directory
elif [ "$1" = "dockerize" ];then
    find ../target/ -type f \( -name "*.jar" -not -name "*sources.jar" \) -exec cp {} ../infrastructure/$SERVICE_NAME.jar \;
    aws ecr create-repository --repository-name ${SERVICE_NAME:?} --region ${REGION} || true
    aws ecr get-login-password \
    --region ${REGION} \
    | docker login \
    --username AWS \
    --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

    cd infrastructure
    docker build -t ${SERVICE_NAME}:${SERVICE_TAG} .
    docker tag ${SERVICE_NAME}:${SERVICE_TAG} ${ECR_REPO_URL}:${SERVICE_TAG}
    docker push ${ECR_REPO_URL}:${SERVICE_TAG}
elif [ "$1" = "plan" ];then
    cd infrastructure
    terraform init -backend-config="app-prod.config"
    terraform plan -var-file="production.tfvars" -var "docker_image_url=$ECR_REPO_URL:$SERVICE_TAG"
elif [ "$1" = "deploy" ];then
    cd infrastructure
    terraform init -backend-config="app-prod.config"
    terraform apply -var-file="production.tfvars" -var "docker_image_url=$ECR_REPO_URL:$SERVICE_TAG" -auto-approve
elif [ "$1" = "destroy" ];then
    cd infrastructure
    terraform init -backend-config="app-prod.config"
    terraform destroy -var-file="production.tfvars" -var "docker_image_url=$ECR_REPO_URL:$SERVICE_TAG" -auto-approve
fi

# And again, I'm going to copy my init command just to be sure about our 
# initialization and the identical

# versions of our command.