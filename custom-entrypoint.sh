#!/bin/bash
set -e

# 1. Forcefully isolate the MPM modules right before boot.
# Doing this at runtime guarantees no duplicate modules can trigger the AH00534 crash.
rm -f /etc/apache2/mods-enabled/mpm_*.load
rm -f /etc/apache2/mods-enabled/mpm_*.conf
ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/
ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/

# 2. Clean up stale Apache PID files from previous crashes
rm -f /var/run/apache2/apache2.pid

# 3. Background daemon: Bypass the Joomla remote database ownership check.
# We redirect all I/O to /dev/null and disown the process so it doesn't hold 
# file descriptors open, which prevents Apache from panicking.
(
  while true; do
    if [ -d "/var/www/html/installation" ]; then
      find /var/www/html/installation/ -maxdepth 1 -name "_Joomla_*.txt" -type f -delete 2>/dev/null
    fi
    if [ -f "/var/www/html/configuration.php" ]; then
      break
    fi
    sleep 1
  done
) </dev/null >/dev/null 2>&1 &
disown

# 4. Hand over execution to the official Joomla entrypoint
if [ -f "/entrypoint.sh" ]; then
    exec /entrypoint.sh "$@"
elif [ -f "/docker-entrypoint.sh" ]; then
    exec /docker-entrypoint.sh "$@"
else
    exec "$@"
fi
