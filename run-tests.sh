#!/bin/bash

# Check if WordPress is running
curl -s http://localhost:9090 | grep -q "WordPress" && echo "WordPress is running" || exit 1

# Database connection test
docker exec -it mysql_container mysqladmin ping -hlocalhost -uroot -p"root_password" || exit 1

echo "All tests passed!"
