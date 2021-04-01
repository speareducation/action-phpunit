FROM 009255884135.dkr.ecr.us-east-1.amazonaws.com/spear/php-fpm-apache2-alpine:1.4.1
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
