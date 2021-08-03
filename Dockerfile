FROM 009255884135.dkr.ecr.us-east-1.amazonaws.com/spear/php74-fpm-apache2-alpine:main

RUN echo "extension=pcov.so" > /etc/php7/conf.d/00_pcov.ini

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
