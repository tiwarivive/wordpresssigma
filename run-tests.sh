#!/bin/bash
# Check if WordPress is running
curl -s http://localhost:8080 | grep -q "WordPress" && echo "WordPress is running" || exit 1

# Database connection test
docker exec -it wordpress-db mysqladmin ping -hlocalhost -uroot -p"${MYSQL_ROOT_PASSWORD}" || exit 1

echo "All tests passed!"

# Database connection test
docker exec -it wordpress-db mysqladmin ping -hlocalhost -uroot -p"${MYSQL_ROOT_PASSWORD}" || exit 1

echo "All tests passed!"
