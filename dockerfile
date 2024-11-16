# Use the official WordPress image as the base
FROM wordpress:latest

# Maintainer info (optional)
LABEL maintainer="tiwarivive@gmail.com"

# Copy custom files into the container (if any)
COPY ./wp-content /var/www/html/wp-content
