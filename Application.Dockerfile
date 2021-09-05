FROM php:7.4

# update latest repository
RUN apt-get update -y && apt install -y apt-utils sudo unzip curl cron less


# composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin

COPY composer.json /var/www/html/
COPY composer.lock /var/www/html/
RUN cd /var/www/html/ && \
    composer install

RUN rm -rf /var/lib/apt/lists/*

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chown -R www-data: /var/www/html
COPY . /var/www/html/
RUN (crontab -l ; echo "* * * * * /usr/local/bin/php /var/www/html/index.php >> /var/www/html/log.log") | crontab

WORKDIR /var/www/html/
