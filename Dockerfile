FROM spear/php-fpm-apache2-alpine:1.3.7
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
