#!/bin/sh

set -e

# Create media directory with the correct permissions
mkdir -p /vol/web/media/uploads/recipe
chmod -R 777 /vol/web/media/uploads/recipe

# Execute the CMD from the Dockerfile or docker-compose.yml
exec "$@"
