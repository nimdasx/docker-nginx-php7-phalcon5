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

#psr (phalcon butuh ini)
WORKDIR /usr/local/src
RUN git clone --depth=1 https://github.com/jbboehr/php-psr.git
WORKDIR /usr/local/src/php-psr
RUN phpize \
    && ./configure \
    && make \
    && make test \
    && make install
#RUN echo extension=psr.so | tee -a /usr/local/etc/php/conf.d/psr.ini
WORKDIR /
RUN rm -rf /usr/local/src/php-psr
RUN docker-php-ext-enable psr

#phalcon
WORKDIR /usr/local/src
#RUN git clone -b 4.2.x --depth=1 "git://github.com/phalcon/cphalcon.git"
RUN git clone "git://github.com/phalcon/cphalcon.git"
WORKDIR /usr/local/src/cphalcon
#RUN git checkout 3241d96e4bb01dc7746b74c9ce586250b8887c46
WORKDIR /usr/local/src/cphalcon/build
RUN ./install
WORKDIR /
RUN rm -rf /usr/local/src/cphalcon
RUN docker-php-ext-enable phalcon