FROM spear/php-fpm:1.11-7.2
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
