#!/usr/bin/env bash

# Set environments
sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php-fpm.conf
sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php-fpm.d/www.conf
sed -i "s|;*listen\s*=\s*/||g" /etc/php-fpm.d/www.conf
echo "date.timezone = ${TIMEZONE}" > /etc/php.ini

exec "$@"