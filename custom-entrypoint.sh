#!/bin/bash
set -e

# 1. Bind Apache to Railway's dynamic PORT
# Without this, Railway assumes the app is dead and aggressively restarts it.
if [ -n "$PORT" ]; then
    sed -i "s/Listen 80/Listen $PORT/g" /etc/apache2/ports.conf
    sed -i "s/:80/:$PORT/g" /etc/apache2/sites-available/000-default.conf
fi

# 2. Clean up stale Apache PID files from ungraceful restarts
rm -f /var/run/apache2/apache2.pid

# 3. Background daemon: Bypass the Joomla remote database ownership check
(
  while true; do
    if [ -d "/var/www/html/installation" ]; then
      find /var/www/html/installation/ -maxdepth 1 -name "_Joomla_*.txt" -type f -delete 2>/dev/null
    fi
    
    # Stop daemon when installation finishes and the configuration file is generated
    if [ -f "/var/www/html/configuration.php" ]; then
      break
    fi
    
    sleep 1
  done
) &

# 4. Hand over execution to the official Joomla entrypoint
if [ -f "/entrypoint.sh" ]; then
    exec /entrypoint.sh "$@"
elif [ -f "/docker-entrypoint.sh" ]; then
    exec /docker-entrypoint.sh "$@"
else
    exec "$@"
fi
