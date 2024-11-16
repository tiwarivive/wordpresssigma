ARG BASE_IMAGE
FROM ${BASE_IMAGE}
LABEL maintainer="tiwarivive@gmail.com"

# Ensure wp-content exists (optional)
RUN mkdir -p /var/www/html/wp-content

# Copy custom wp-content directory (if it exists)
COPY ./wp-content /var/www/html/wp-content

