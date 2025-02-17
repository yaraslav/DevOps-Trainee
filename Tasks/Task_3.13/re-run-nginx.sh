#!/bin/bash

# Re-Start Nginx
echo -e "\nStopping and deleting container which is already existed..."
if [ "$(docker ps -aq -f name=inno-dkr-02)" ]; then
docker rm -f inno-dkr-02
fi
echo -e "\n...and Starting Nginx again with -it mode for 'attach' using!"
if docker run -dit --name inno-dkr-02 -p 8889:80 \
  --mount type=bind,source=/home/ubuntu/nginx.conf,target=/etc/nginx/nginx.conf,readonly \
  nginx:stable
; then
    echo -e "\nNginx started successfully.\n"
else
    echo -e "\nFailed to start Nginx.\n"
fi
