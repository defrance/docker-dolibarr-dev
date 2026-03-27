FROM php:8.2-apache
RUN apt-get update && apt-get install -y \
  imagemagick \
  libc-client-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmagickwand-dev --no-install-recommends \
  libpng-dev \
  libkrb5-dev \
  libxml2-dev \
  libzip-dev \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/* \
  && a2enmod rewrite \
  && docker-php-ext-install exif calendar intl zip \
  && docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install -j$(nproc) gd \
  && pecl install imagick && docker-php-ext-enable imagick \
  && pecl install xdebug-3.0.0 && docker-php-ext-enable xdebug \
  && docker-php-ext-install pdo pdo_pgsql pgsql