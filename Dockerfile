FROM webdevops/php-nginx:7.4-alpine

LABEL maintainer="nimdasx@gmail.com" \
    description="nginx php-7 phalcon-5"

RUN ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
    && echo "Asia/Jakarta" > /etc/timezone \
    && apk add --no-cache nodejs npm

COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini
COPY vhost.conf /opt/docker/etc/nginx/vhost.conf

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions sqlsrv pdo_sqlsrv phalcon-5.4.0

# phalcon 5.4 adalah versi terakhir yang support php 7.4