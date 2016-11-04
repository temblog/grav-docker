FROM php:7-fpm-alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk upgrade -U && \
    apk add --update --repository=http://dl-4.alpinelinux.org/alpine/edge/testing \
    gd openssl php7-zip php7-mbstring php7-xml php7-opcache php7-apcu

RUN rm -rf /var/cache/apk/* &rm -rf /tmp/*

WORKDIR /tmp

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php --install-dir=/usr/bin --filename=composer \
&& php -r "unlink('composer-setup.php');" \
&& composer require "getgrav/grav" --prefer-source --no-interaction \

ENV HOME=/var/www/

WORKDIR $HOME/app

composer create-project getgrav/grav

COPY . $HOME/app

ADD php-fpm/php-fpm.conf /etc/php5/

RUN composer  

CMD ["php-fpm", "-F"]

EXPOSE 9000