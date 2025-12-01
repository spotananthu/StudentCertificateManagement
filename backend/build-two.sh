#!/usr/bin/env bash
set -euo pipefail

DOCKER_USER="sachintp"
TAG="latest"
SERVICE="verification-service"

SERVICE_DIR="./backend/${SERVICE}"
IMAGE="${DOCKER_USER}/${SERVICE}:${TAG}"

echo "🚀 Building and pushing image for ${SERVICE}"
cd "${SERVICE_DIR}"

docker build -t "${IMAGE}" .
docker push "${IMAGE}"

cd - > /dev/null
echo "✔ Done: ${IMAGE}"
echo "🎉 Verification-service image pushed successfully!"
