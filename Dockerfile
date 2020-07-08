FROM spear/php-fpm-apache2:2.12-2.4.29-1ubuntu4.11-7.2.24
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]