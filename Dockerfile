FROM webdevops/php-nginx:7.4-alpine

LABEL maintainer="nimdasx@gmail.com"
LABEL description="nginx php74"

#set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
    && echo "Asia/Jakarta" > /etc/timezone

#config php
COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini

#sqlsrv
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.6.1.1-1_amd64.apk \
    && curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.6.1.1-1_amd64.apk \
    && apk add --allow-untrusted msodbcsql17_17.6.1.1-1_amd64.apk \
    && apk add --allow-untrusted mssql-tools_17.6.1.1-1_amd64.apk \
    && apk update \
    && apk add autoconf make g++ unixodbc-dev \
    && pecl install sqlsrv \
    && pecl install pdo_sqlsrv \
    && echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/10_pdo_sqlsrv.ini \
    && echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/00_sqlsrv.ini

RUN apk add file

#apk
RUN apk add autoconf make g++

#phalcon 5 stable
RUN pecl install phalcon-5.0.3 \
    && docker-php-ext-enable phalcon