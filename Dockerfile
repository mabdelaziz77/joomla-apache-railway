# Default values — overridden by Railway variables during deploy
ARG JOOMLA_VERSION=5
ARG PHP_VERSION=8.2

FROM joomla:${JOOMLA_VERSION}-php${PHP_VERSION}-apache

# Forcefully disable conflicting Apache Multi-Processing Modules
# This prevents the AH00534 crash on cloud platforms
RUN a2dismod mpm_event mpm_worker || true \
    && a2enmod mpm_prefork

COPY custom-entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

ENTRYPOINT ["custom-entrypoint.sh"]
CMD ["apache2-foreground"]
