# PHP7-FPM
FROM php:7-fpm

# Install OS utilities
RUN apt-get update
RUN apt-get -y install \
  curl \
  iputils-ping \
  net-tools \
  git \
  zip \
  unzip \
  wget \
  vim

# Install Composer
ENV composer_tmp_dir /tmp/composer
RUN mkdir ${composer_tmp_dir}
RUN php -r "copy('https://getcomposer.org/installer', '${composer_tmp_dir}/composer-setup.php');"
RUN php -r "if (hash_file('SHA384', '${composer_tmp_dir}/composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php ${composer_tmp_dir}/composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('${composer_tmp_dir}/composer-setup.php');"
RUN composer --version
RUN rmdir ${composer_tmp_dir}

# Enable PHP core extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
  && docker-php-ext-install -j$(nproc) iconv mcrypt \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd

# Required by Grav
RUN docker-php-ext-install zip

ENV HOME=/var/www/

#Install Grav using Composer
RUN composer create-project getgrav/grav $HOME/app
