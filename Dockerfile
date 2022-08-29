# # FROM php:5.6-apache
# # COPY phpunit.xml /usr/local/etc/php/
# # RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpngl2-dev libmcrypt-dev mysql-client \
# # && docker-pho-ext-install pdo mysql mysql gd iconv \ 
# # 8& docker-php-ext-install mbstring \
# # && docker-php-ext-install mcrypt 

# # RUN npm install -g  docker-php-ext-install
# # COPY ./blogsite.com.conf /etc/apache2/sites-available/
# # COPY ./hosts /etc/hosts 
# # RUN a2enmod rewrite


# # #RUN a2enmod mcrypt
# # RUN service apache2 restart
# # WORKDIR /etc/apache2/sites-available/
# # RUN azens1te blogs1te.com.conf

# # EXPOSE 8080

# # FROM node:latest AS node
# # FROM php:7.4-fpm


# # RUN apt-get update && apt-get install -y nodejs npm

# # COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
# # COPY --from=node /usr/local/bin/node /usr/local/bin/node
# # RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# # RUN mkdir -p /usr/src/app
# # WORKDIR /usr/src/app

# # COPY package.json /usr/src/app
# # RUN npm install
# # # Bundle app source
# # COPY . .


# # COPY . /usr/src/app

# # EXPOSE 8080

# # CMD [ "node", "server.js" ]


# FROM php:8.0.23RC1-zts-alpine3.16

# RUN apk update && apk add curl && \
#   curl -sS https://getcomposer.org/installer | php \
#   && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer

# # RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
# #   && apk --no-cache add --virtual .ext-deps libmcrypt-dev freetype-dev \
# #   libjpeg-turbo-dev libpng-dev libxml2-dev msmtp bash openssl-dev pkgconfig \
# #   && docker-php-source extract \
# #   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
# #                                    --with-png-dir=/usr/include/ \
# #                                    --with-jpeg-dir=/usr/include/ \
# #   && docker-php-ext-install gd mcrypt mysqli pdo pdo_mysql zip opcache \
# #   && pecl install mongodb redis xdebug \
# #   && docker-php-ext-enable mongodb \
# #   && docker-php-ext-enable redis \
# #   && docker-php-ext-enable xdebug \
# #   && docker-php-source delete \
# #   && apk del .build-deps

# WORKDIR /var/www/html
# COPY .env.example .env/
# COPY composer.json composer.lock ./
# RUN  composer update
# RUN chmod +x artisan
# RUN  composer install 


# COPY . .
# RUN chmod +x artisan

# #RUN composer dump-autoload --optimize && composer run-script post-install-cmd

# CMD bash -c "composer install && php artisan serve --host 0.0.0.0 --port 5001"


FROM composer as builder
WORKDIR /
COPY composer.* ./
COPY artisan /
COPY . /
RUN composer update 
RUN composer install
FROM php:8.1-fpm-alpine
COPY --from=builder /vendor /var/www/vendor
COPY package.json /usr/src/app
RUN npm install
RUN npm run dev
# # # Bundle app source
COPY . .


# # COPY . /usr/src/app
COPY .env.example .env/
COPY composer.json composer.lock ./
CMD bash -c "composer install && php artisan serve --host 0.0.0.0 --port 5001"