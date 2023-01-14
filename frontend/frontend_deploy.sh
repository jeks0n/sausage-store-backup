#!/bin/bash
set +e
cat > .env <<EOF
BACKEND_URL=${BACKEND_URL}
EOF
docker network create -d bridge sausage_network || true
docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
docker pull $CI_REGISTRY_IMAGE/$GL_DOCKER_IMAGE_FRONTEND_NAME:latest
docker stop $GL_DOCKER_IMAGE_FRONTEND_NAME || true
docker rm $GL_DOCKER_IMAGE_FRONTEND_NAME || true
set -e
docker run -d --name ${GL_DOCKER_IMAGE_FRONTEND_NAME} \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    -p 80:80 \
    ${CI_REGISTRY_IMAGE}/${GL_DOCKER_IMAGE_FRONTEND_NAME}:latest