#!/bin/bash
set +e
cat > .env.frontend <<EOF
BACKEND_URL=${BACKEND_URL}
EOF
docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
docker pull $CI_REGISTRY_IMAGE/$GL_DOCKER_IMAGE_FRONTEND_NAME:latest
docker stop frontend || true
docker rm frontend || true
set -e
docker-compose --env-file .env.frontend up -d frontend
