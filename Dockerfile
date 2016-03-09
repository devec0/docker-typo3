FROM debian:jessie
MAINTAINER James Hebden <james@ec0.io>

RUN apt-get update && apt-get upgrade -y

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y vim php5-apcu curl git exim4 nginx mariadb-server php5-fpm php5-mysql php5-gd php5-curl libssh2-php php5-dev supervisor

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN curl -L -o /tmp/typo3.tar.gz https://get.typo3.org/current

RUN cd /var/www && tar zxfv /tmp/typo3.tar.gz

RUN mkdir -p /var/www/default
RUN ln -s /var/www/typo3_src-7.6.4 /var/www/default/typo3_src
RUN ln -s typo3_src/typo3 /var/www/default/typo3
RUN ln -s typo3_src/index.php /var/www/default/index.php

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx-default.conf /etc/nginx/sites-enabled/default
COPY conf/supervisor.conf /etc/supervisor/supervisord.conf

RUN find /var/www -xtype d -exec chmod 0750 {} \;
RUN find /var/www -xtype f -exec chmod 0650 {} \;
RUN chown -R www-data:www-data /var/www

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

EXPOSE 80
