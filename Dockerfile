FROM ubuntu:xenial
MAINTAINER Ray Hwang <ray.hwang@originalfunction.com>

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install supervisor git apache2 curl mysql-server php libapache2-mod-php php-mcrypt php-mysql php-curl php-gd && \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add image configuration and scripts
ADD docker/start-apache2.sh /start-apache2.sh
ADD docker/start-mysqld.sh /start-mysqld.sh
ADD docker/mysql-setup.sh /mysql-setup.sh
ADD docker/run.sh /run.sh
RUN chmod 755 /*.sh

ADD docker/my.cnf /etc/mysql/conf.d/my.cnf
ADD docker/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD docker/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Add MySQL utils
RUN usermod -d /var/lib/mysql/ mysql

# config to enable .htaccess
ADD docker/apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Configure /app folder with sample app
# RUN git clone https://github.com/fermayo/hello-world-lamp.git /app

RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#Environment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/app" ]

EXPOSE 80 3306
CMD ["/run.sh"]
