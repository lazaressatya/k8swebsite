# Use a lightweight Nginx base image
FROM nginx:alpine

# Copy your static website files into the Nginx web server's default public directory
# Ensure your static files (index.html, CSS, JS, images, etc.) are in the same directory as the Dockerfile
COPY . /usr/share/nginx/html

# Expose port 80, which Nginx listens on by default
EXPOSE 80

# Command to run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
