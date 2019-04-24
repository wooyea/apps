FROM centos:7
RUN yum install -y php apache2 php-pear
RUN pecl install apc

COPY apache2-foreground /usr/local/bin/
WORKDIR /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
