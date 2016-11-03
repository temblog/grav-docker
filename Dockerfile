FROM alpine:3.4

RUN apk add --update php5-fpm php5-apcu php5-curl php5-gd php5-iconv php5-imagick \
      php5-json php5-intl php5-mcrypt php5-mysql  php5-opcache php5-openssl php5-pdo \
      php5-pdo_mysql php5-mysqli php5-xml php5-dom php5-phar php5-pcntl wget git

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