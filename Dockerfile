###########################################################################################
#
#                         Image Docker pour l'API sygal-import-ws
#
###########################################################################################

FROM debian:bullseye AS distrib

ENV TZ="Europe/Paris"

LABEL maintainer="Bertrand GAUTHIER <bertrand.gauthier at unicaen.fr>"

ARG PHP_VERSION

ENV PHP_VERSION=${PHP_VERSION}

ENV HTTP_PROXY=${http_proxy} \
    HTTPS_PROXY=${https_proxy} \
    NO_PROXY=${no_proxy} \
    http_proxy=${http_proxy} \
    https_proxy=${https_proxy} \
    no_proxy=${no_proxy}

RUN apt-get -qq update && \
    apt-get install -y \
        apache2 \
        ca-certificates \
        curl \
        gcc \
        git \
        ldap-utils \
        libaio1 \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libmemcached-tools \
        libssl-dev \
        libxml2-dev \
        make \
        memcached \
        nano \
        netcat-openbsd \
        ssh \
        ssl-cert \
        unzip \
        vim \
        wget \
        zlib1g-dev


###########################################################################################

FROM composer:2.5.5 AS get-composer

FROM distrib AS php

ENV PHP_CONF_LOCAL_DIR=docker/configs/php \
    PHP_CONF_DIR=/etc/php/${PHP_VERSION} \
    FPM_PHP_LOG_FILE=/var/log/php-fpm.log

# Repositories fournissant PHP 5.x, 7.x et 8.x
RUN apt-get -qq update && \
    apt-get -y install apt-transport-https lsb-release ca-certificates curl && \
    curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
#    wget --no-check-certificate -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
#    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

RUN apt-get -qq update && \
    apt-get install -y \
        php-pear \
        php${PHP_VERSION} \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-dev \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-gettext \
        php${PHP_VERSION}-iconv \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-ldap \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-memcached \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-xdebug \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-readline

# Forçage de la version de PHP CLI
RUN update-alternatives --set php /usr/bin/php${PHP_VERSION}

# Package PHP Oracle OCI8
ENV OCI8_PACKAGE="oci8-3.0.1"
ADD docker/resources/instantclient-basiclite-linux.x64-18.5.0.0.0dbru.zip /tmp/
ADD docker/resources/instantclient-sdk-linux.x64-18.5.0.0.0dbru.zip /tmp/
ADD docker/resources/instantclient-sqlplus-linux.x64-18.5.0.0.0dbru.zip /tmp/
RUN unzip -o /tmp/instantclient-basiclite-linux.x64-18.5.0.0.0dbru.zip -d /usr/local/ && \
    unzip -o /tmp/instantclient-sdk-linux.x64-18.5.0.0.0dbru.zip -d /usr/local/ && \
    unzip -o /tmp/instantclient-sqlplus-linux.x64-18.5.0.0.0dbru.zip -d /usr/local/ && \
    ln -sf /usr/local/instantclient_18_5 /usr/local/instantclient && \
    ln -sf /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
    echo 'instantclient,/usr/local/instantclient' | pecl install ${OCI8_PACKAGE} && \
    echo "extension=oci8.so" > ${PHP_CONF_DIR}/fpm/conf.d/30-php-oci8.ini && \
    echo "extension=oci8.so" > ${PHP_CONF_DIR}/cli/conf.d/30-php-oci8.ini && \
    echo "/usr/local/instantclient" > /etc/ld.so.conf.d/oracle-instantclient.conf && ldconfig

# Composer
COPY --from=get-composer /usr/bin/composer /usr/local/bin/composer

# Configuration PHP, php-fpm.
ADD ${PHP_CONF_LOCAL_DIR}/fpm/pool.d/www.conf.part /tmp/
RUN cat /tmp/www.conf.part >> ${PHP_CONF_DIR}/fpm/pool.d/www.conf && rm /tmp/www.conf.part
ADD ${PHP_CONF_LOCAL_DIR}/fpm/conf.d/99-sygal.ini ${PHP_CONF_DIR}/fpm/conf.d/
ADD ${PHP_CONF_LOCAL_DIR}/cli/conf.d/99-sygal.ini ${PHP_CONF_DIR}/cli/conf.d/

# Création du fichier pour les logs FPM (cf. fpm/pool.d/www.conf.part)
RUN touch ${FPM_PHP_LOG_FILE} && \
    chown www-data:www-data ${FPM_PHP_LOG_FILE}


###########################################################################################


FROM php AS apache

ENV APACHE_CONF_LOCAL_DIR=docker/configs/apache \
    APACHE_CONF_DIR=/etc/apache2

RUN a2enmod actions alias rewrite ssl proxy proxy_fcgi setenvif headers && \
    a2dismod mpm_event && a2enmod mpm_worker
ADD ${APACHE_CONF_LOCAL_DIR}/conf-available/security.conf ${APACHE_CONF_DIR}/conf-available/security-unicaen.conf

RUN a2disconf security.conf && \
    a2enconf security-unicaen.conf \
             php${PHP_VERSION}-fpm

# Symlink apache access and error logs to stdout/stderr so Docker logs shows them.
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stdout /var/log/apache2/other_vhosts_access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

# Configuration Apache.
ADD ${APACHE_CONF_LOCAL_DIR}/apache-ports.conf     ${APACHE_CONF_DIR}/ports.conf
ADD ${APACHE_CONF_LOCAL_DIR}/apache-site.conf      ${APACHE_CONF_DIR}/sites-available/app.conf
ADD ${APACHE_CONF_LOCAL_DIR}/apache-site-ssl.conf  ${APACHE_CONF_DIR}/sites-available/app-ssl.conf
RUN a2ensite app app-ssl


###########################################################################################


FROM apache AS bootstrap

# Nettoyage
RUN apt-get autoremove -y && apt-get clean && rm -rf /tmp/* /var/tmp/*

# Copie les fichiers situés dans ./docker/entrypoint.d dans le dossier /entrypoint.d de l'image.
# Les scripts exécutables parmi eux seront exécutés au démarrage du container (cf. entrypoint.sh).
# Attention : les noms de fichiers ne doivent être constitués que de lettres minuscules ou majuscules,
# de chiffres, de tirets bas (underscore) ou de tirets ; extension interdite, donc.
#ADD docker/entrypoint.d/* /entrypoint.d/
## Copie des scripts complémentaires à lancer au démarrage du container.
COPY docker/entrypoint.d/* /entrypoint.d/

# Entry point
ADD docker/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
CMD ["/sbin/entrypoint.sh"]


COPY . /app

WORKDIR /app

RUN composer install --prefer-dist --optimize-autoloader --no-interaction

RUN vendor/bin/laminas-development-mode disable
