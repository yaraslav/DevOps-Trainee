# Use the official Nginx image from Docker Hub
FROM ubuntu:18.04

WORKDIR /etc/nginx

RUN apt-get update && apt-get install -y nginx && apt-get clean && rm -rf /var/lib/apt/lists/*  

# Create a new system user called 'nginx' (optional)
RUN useradd -r nginx

# Copy custom Nginx configuration (optional)
COPY nginx.conf /etc/nginx/nginx.conf

# # Copy static website files to the Nginx container
# COPY ./html /usr/share/nginx/html
VOLUME [ "/var/lib/nginx" ]
# Expose port 80 for the web server
EXPOSE 80

ENTRYPOINT [ "nginx" ]

# Start Nginx in the foreground (required to keep the container running)
CMD ["-g", "daemon off;"]
