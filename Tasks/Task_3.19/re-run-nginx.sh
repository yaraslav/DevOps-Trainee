#!/bin/bash
# Re-Start Nginx
echo -e "\nStopping and deleting container which is already existed..."
if [ "$(docker ps -aq)" ]; then
docker rm -f $(docker ps -aq)
fi
echo -e "\n...and Starting Nginx again with -it mode for 'attach' using!"
if docker run -dit \
  --name inno-dkr-08  \
  -p 127.0.0.1:8900:80 \
  nginx:inno-dkr-08;then
    echo -e "\nNginx started successfully.\n"
else
    echo -e "\nFailed to start Nginx.\n"
fi