# Use the official Nginx image from Docker Hub
FROM nginx:stable

# Copy custom Nginx configuration (optional)
COPY nginx.conf /etc/nginx/nginx.conf

# # Copy static website files to the Nginx container
# COPY ./html /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx in the foreground (required to keep the container running)
CMD ["nginx", "-g", "daemon off;"]
