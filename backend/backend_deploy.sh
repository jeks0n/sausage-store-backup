#!/bin/bash
set +e
cat > .env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
LOG_PATH=/opt/log/
REPORT_PATH=/opt/log/
EOF
docker network create -d bridge sausage_network || true
docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
docker pull $CI_REGISTRY_IMAGE/$GL_DOCKER_IMAGE_BACKEND_NAME:latest
docker stop $GL_DOCKER_IMAGE_BACKEND_NAME || true
docker rm $GL_DOCKER_IMAGE_BACKEND_NAME || true
set -e
docker run -d --name $GL_DOCKER_IMAGE_BACKEND_NAME \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    $CI_REGISTRY_IMAGE/$GL_DOCKER_IMAGE_BACKEND_NAME:latest
