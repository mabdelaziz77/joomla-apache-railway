#!/bin/bash
set -e

# Background daemon: Bypasses the Joomla remote database ownership check
# Monitors the installation folder and automatically deletes the generated token file.
(
  while true; do
    if [ -d "/var/www/html/installation" ]; then
      find /var/www/html/installation/ -maxdepth 1 -name "_Joomla_*.txt" -type f -delete 2>/dev/null
    else
      # Exit the loop once the installation directory is deleted post-install
      break
    fi
    sleep 2
  done
) &

# Hand over execution to the official Joomla entrypoint
if [ -f "/entrypoint.sh" ]; then
    exec /entrypoint.sh "$@"
elif [ -f "/docker-entrypoint.sh" ]; then
    exec /docker-entrypoint.sh "$@"
else
    exec "$@"
fi
