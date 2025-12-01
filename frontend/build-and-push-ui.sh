#!/bin/bash

PORTALS=("admin-dashboard" "employer-portal" "student-portal" "university-portal")

for portal in "${PORTALS[@]}"; do
  IMAGE="sachintp/${portal}:latest"
  DIR="frontend/${portal}"

  echo "🚀 Building & pushing: $IMAGE"
  docker build -t $IMAGE $DIR
  docker push $IMAGE
done

echo "🎉 Finished building & pushing all UI images!"
