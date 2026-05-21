#!/bin/bash
set -e

# Background daemon: Bypasses the Joomla remote database ownership check
(
  while true; do
    # If the installation directory exists, watch for the ownership file and delete it
    if [ -d "/var/www/html/installation" ]; then
      find /var/www/html/installation/ -maxdepth 1 -name "_Joomla_*.txt" -type f -delete 2>/dev/null
    fi

    # Stop the daemon once Joomla is fully installed
    if [ -f "/var/www/html/configuration.php" ]; then
      break
    fi
    
    sleep 1
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
