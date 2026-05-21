# Default values — overridden by Railway variables
ARG JOOMLA_VERSION=5
ARG PHP_VERSION=8.2

FROM joomla:${JOOMLA_VERSION}-php${PHP_VERSION}-apache

# Forcefully isolate the prefork module. 
# This guarantees no MPM conflicts can occur on ungraceful restarts.
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf \
    && ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/ \
    && ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/

COPY custom-entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

ENTRYPOINT ["custom-entrypoint.sh"]
CMD ["apache2-foreground"]
