FROM php:8.2-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
  imagemagick \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmagickwand-dev \
  libpng-dev \
  libssl-dev \
  libxml2-dev \
  libzip-dev \
  sqlite3 \
  libsqlite3-dev \
  && rm -rf /var/lib/apt/lists/* \
  && a2enmod rewrite \
  && docker-php-ext-install exif calendar intl zip \
  && docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install -j$(nproc) gd \
  && pecl install imagick && docker-php-ext-enable imagick \
  && pecl install xdebug && docker-php-ext-enable xdebug\
  && docker-php-ext-install ftp \
  && docker-php-ext-install pdo pdo_sqlite 

# Augmenter les limites PHP
RUN echo "upload_max_filesize=1G" > /usr/local/etc/php/conf.d/uploads.ini \
 && echo "post_max_size=1G" >> /usr/local/etc/php/conf.d/uploads.ini \
 && echo "memory_limit=2G" >> /usr/local/etc/php/conf.d/uploads.ini \
 && echo "max_execution_time=600" >> /usr/local/etc/php/conf.d/uploads.ini \
 && echo "max_input_time=600" >> /usr/local/etc/php/conf.d/uploads.ini