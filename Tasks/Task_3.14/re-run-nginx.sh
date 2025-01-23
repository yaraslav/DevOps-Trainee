#!/bin/bash

# Re-Start Nginx
echo -e "\nStopping and deleting container which is already existed..."
if [ "$(docker ps -aq)" ]; then
docker rm -f $(docker ps -aq)
fi
echo -e "\n...and Starting Nginx again with -it mode for 'attach' using!"
if docker run -d \
  --name inno-dkr-04 \
  -p 8891:80 \
  --mount type=bind,source=/home/ubuntu/nginx.conf,target=/etc/nginx/nginx.conf,readonly \
  --mount source=inno-dkr-04-volume,target=/var/log/nginx \
  nginx:stable;then
    echo -e "\nNginx started successfully.\n"
else
    echo -e "\nFailed to start Nginx.\n"
fi



