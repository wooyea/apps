FROM php:5.6-apache

ADD sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
	libldap-2.4-2 \
        libldap2-dev \
        libc-client2007e-dev libkrb5-dev unzip cron re2c \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && mkdir /usr/ldap \
    && ln -s /usr/include /usr/ldap/include \
    && ln -s /usr/lib/x86_64-linux-gnu/ /usr/ldap/lib \
    && docker-php-ext-configure ldap --with-ldap=/usr/ldap \
    && docker-php-ext-install -j$(nproc) ldap \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) mysql \
    && docker-php-ext-configure mysqli \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-configure pdo_mysql \
    && docker-php-ext-install -j$(nproc) pdo_mysql \ 
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap 

#
#    && docker-php-ext-install -j$(nproc) mysql \
#    && docker-php-ext-enable mysql \

CMD ["apache2-foreground"]
