#!/bin/bash

IMAGE_TAG=$1
CONTAINER_NAME=$2

if [ -z "$IMAGE_TAG" ] || [ -z "$CONTAINER_NAME" ]; then
    echo "Usage: $0 <image_tag> <container_name>"
    exit 1
fi

echo "\n...and Build Nginx image again!"

docker build -t $IMAGE_TAG .

echo -e "\nDeleting container which is already existed..."

if docker rm -f $CONTAINER_NAME; then
    echo "Deleted existing container $CONTAINER_NAME."
else
    echo "No existing container $CONTAINER_NAME found."
fi

echo -e "\n...and Run  Nginx image again!"
if docker run -dit \
    --name $CONTAINER_NAME \
    -p 127.0.0.1:8901:80 \
    $IMAGE_TAG; then
        echo -e "\nNginx started successfully.\n"
else
        echo -e "\nFailed to start Nginx.\n"
fi
