#!/bin/bash
sudo apt-get update -y

sudo apt-get install -y nginx

sudo rm -r /var/www/html/index.nginx-debian.html

TOKEN=$(curl --request PUT "http://169.254.169.254/latest/api/token" --header "X-aws-ec2-metadata-token-ttl-seconds: 3600")
LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 --header "X-aws-ec2-metadata-token: $TOKEN") 

echo "My private IP is $LOCAL_IP" > index.nginx-debian.html

sudo systemctl reload nginx