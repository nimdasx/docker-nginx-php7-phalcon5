FROM webdevops/php-nginx:7.4-alpine

LABEL maintainer="nimdasx@gmail.com" \
    description="nginx php-7 phalcon-5"

# 1. Backport security patch (CVE-2026-109618 & CVE-2026-109619) & rebuild PHP
COPY CVE-2026-109618-109619.patch /tmp/CVE-2026-109618-109619.patch

RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        dpkg-dev dpkg \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c \
        argon2-dev \
        coreutils \
        curl-dev \
        gnu-libiconv-dev \
        libsodium-dev \
        libxml2-dev \
        linux-headers \
        oniguruma-dev \
        openssl-dev \
        readline-dev \
        sqlite-dev \
        patch \
    ; \
    rm -vf /usr/include/iconv.h /usr/include/libcharset.h /usr/include/localcharset.h; \
    ln -sv /usr/include/gnu-libiconv/*.h /usr/include/; \
    export \
        CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS" \
    ; \
    docker-php-source extract; \
    cd /usr/src/php; \
    patch -p1 < /tmp/CVE-2026-109618-109619.patch; \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    ./configure \
        --build="$gnuArch" \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --enable-option-checking=fatal \
        --with-mhash \
        --with-pic \
        --enable-ftp \
        --enable-mbstring \
        --enable-mysqlnd \
        --with-password-argon2 \
        --with-sodium=shared \
        --with-pdo-sqlite=/usr \
        --with-sqlite3=/usr \
        --with-curl \
        --with-iconv=/usr \
        --with-openssl \
        --with-readline \
        --with-zlib \
        --disable-phpdbg \
        --with-pear \
        --disable-cgi \
        --enable-fpm \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
    ; \
    make -j "$(nproc)"; \
    find -type f -name '*.a' -delete; \
    make install; \
    find /usr/local -type f -perm '/0111' -exec sh -euxc 'strip --strip-all "$@" || :' -- '{}' +; \
    make clean; \
    cp -v php.ini-* "$PHP_INI_DIR/"; \
    cd /; \
    docker-php-source delete; \
    rm -f /tmp/CVE-2026-109618-109619.patch; \
    apk del --no-network .build-deps; \
    pecl update-channels; \
    rm -rf /tmp/pear ~/.pearrc

# 2. Timezone & Node.js
RUN ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
    && echo "Asia/Jakarta" > /etc/timezone \
    && apk add --no-cache nodejs npm

# 3. Config PHP & Nginx
COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini
COPY vhost.conf /opt/docker/etc/nginx/vhost.conf

# 4. Extensions
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# phalcon 5.4 adalah versi terakhir yang support php 7.4
RUN install-php-extensions sqlsrv pdo_sqlsrv phalcon-5.4.0