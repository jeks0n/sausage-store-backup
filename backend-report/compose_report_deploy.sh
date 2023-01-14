#!/bin/bash
set +e
# Для истории - гитлаб не любит знак &, нужно экранировать
cat > .env.report <<EOF
PORT=8080
DB=${MONGO_URL}
EOF
docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
docker pull $CI_REGISTRY_IMAGE/$GL_DOCKER_IMAGE_REPORT_NAME:latest
docker stop report || true
docker rm report || true
set -e
docker-compose --env-file .env.report up -d backend-report
