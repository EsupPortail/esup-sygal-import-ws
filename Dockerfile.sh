#!/bin/bash

#########################################################################################################
#
#                         Image Docker pour l'API sygal-import-ws
#           traduite en script bash, pour configurer manuellement un serveur Debian
#
# Pré-requis :
#   - Etre root sur le serveur
#   - Avoir récupéré les sources de l'application et être positionné dans leur répertoire
#   - Avoir copié le répertoire ./docker dans le répertoire /tmp du serveur : cp -r ./docker /tmp/
#
#########################################################################################################

#FROM debian:bullseye AS distrib

#ENV TZ="Europe/Paris"

#LABEL maintainer="Bertrand GAUTHIER <bertrand.gauthier at unicaen.fr>"

#ARG PHP_VERSION

export PHP_VERSION=8.0

#ENV HTTP_PROXY=${http_proxy} \
#    HTTPS_PROXY=${https_proxy} \
#    NO_PROXY=${no_proxy} \
#    http_proxy=${http_proxy} \
#    https_proxy=${https_proxy} \
#    no_proxy=${no_proxy}

apt-get -qq update && \
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

#FROM composer:2.5.5 AS get-composer

#FROM distrib AS php

export PHP_CONF_LOCAL_DIR=/tmp/docker/configs/php \
    PHP_CONF_DIR=/etc/php/${PHP_VERSION} #\
#    FPM_PHP_LOG_FILE=/var/log/php-fpm.log

# Repositories fournissant PHP 5.x, 7.x et 8.x
apt-get -qq update && \
    apt-get -y install apt-transport-https lsb-release ca-certificates curl && \
    curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
#    wget --no-check-certificate -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
#    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

apt-get -qq update && \
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
#        php${PHP_VERSION}-xdebug \ --> cf. install à part ci-après
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-readline

# Forçage de la version de PHP CLI
update-alternatives --set php /usr/bin/php${PHP_VERSION}

# Installation manuelle de xdebug 3.2.2, car les 3.3.0/1/2 provoquent une "Segmentation fault" au 22/05/2024 (à cause de PHP 8.0 ?)
pecl install xdebug-3.2.2 && \
    echo "zend_extension=xdebug" > ${PHP_CONF_DIR}/fpm/conf.d/20-xdebug.ini && \
    echo "zend_extension=xdebug" > ${PHP_CONF_DIR}/cli/conf.d/20-xdebug.ini

# Package PHP Oracle OCI8
export OCI8_PACKAGE="oci8-3.0.1"
cp /tmp/docker/resources/instantclient-basiclite-linux.x64-18.5.0.0.0dbru.zip /tmp/
cp /tmp/docker/resources/instantclient-sdk-linux.x64-18.5.0.0.0dbru.zip /tmp/
cp /tmp/docker/resources/instantclient-sqlplus-linux.x64-18.5.0.0.0dbru.zip /tmp/
unzip -o /tmp/instantclient-basiclite-linux.x64-18.5.0.0.0dbru.zip -d /usr/local/ && \
unzip -o /tmp/instantclient-sdk-linux.x64-18.5.0.0.0dbru.zip -d /usr/local/ && \
unzip -o /tmp/instantclient-sqlplus-linux.x64-18.5.0.0.0dbru.zip -d /usr/local/ && \
ln -sf /usr/local/instantclient_18_5 /usr/local/instantclient && \
ln -sf /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
echo 'instantclient,/usr/local/instantclient' | pecl install ${OCI8_PACKAGE} && \
sh -c "echo 'extension=oci8.so' > ${PHP_CONF_DIR}/fpm/conf.d/30-php-oci8.ini" && \
sh -c "echo 'extension=oci8.so' > ${PHP_CONF_DIR}/cli/conf.d/30-php-oci8.ini" && \
sh -c "echo '/usr/local/instantclient' > /etc/ld.so.conf.d/oracle-instantclient.conf" && ldconfig

# Composer
#COPY --from=get-composer /usr/bin/composer /usr/local/bin/composer
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi
php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
mv composer.phar /usr/local/bin/composer

# Configuration PHP, php-fpm.
#cp ${PHP_CONF_LOCAL_DIR}/fpm/pool.d/www.conf.part /tmp/
#cat /tmp/www.conf.part >> ${PHP_CONF_DIR}/fpm/pool.d/www.conf && rm /tmp/www.conf.part
cp ${PHP_CONF_LOCAL_DIR}/fpm/conf.d/99-sygal-import-ws.ini ${PHP_CONF_DIR}/fpm/conf.d/
cp ${PHP_CONF_LOCAL_DIR}/cli/conf.d/99-sygal-import-ws.ini ${PHP_CONF_DIR}/cli/conf.d/

## Création du fichier pour les logs FPM (cf. fpm/pool.d/www.conf.part)
#touch ${FPM_PHP_LOG_FILE} && \
#    chown www-data:www-data ${FPM_PHP_LOG_FILE}


###########################################################################################


#FROM php AS apache

export APACHE_CONF_LOCAL_DIR=/tmp/docker/configs/apache \
    APACHE_CONF_DIR=/etc/apache2

a2enmod actions alias rewrite ssl proxy proxy_fcgi setenvif headers && \
    a2dismod mpm_event && a2enmod mpm_worker
cp ${APACHE_CONF_LOCAL_DIR}/conf-available/security.conf ${APACHE_CONF_DIR}/conf-available/security-unicaen.conf

a2disconf security.conf && \
    a2enconf security-unicaen.conf \
             php${PHP_VERSION}-fpm

# Symlink apache access and error logs to stdout/stderr so Docker logs shows them.
#RUN ln -sf /dev/stdout /var/log/apache2/access.log
#RUN ln -sf /dev/stdout /var/log/apache2/other_vhosts_access.log
#RUN ln -sf /dev/stderr /var/log/apache2/error.log

# Configuration Apache.
cp ${APACHE_CONF_LOCAL_DIR}/ports.conf     ${APACHE_CONF_DIR}/ports.conf
cp ${APACHE_CONF_LOCAL_DIR}/sygal-import-ws.conf      ${APACHE_CONF_DIR}/sites-available/sygal-import-ws.conf
cp ${APACHE_CONF_LOCAL_DIR}/sygal-import-ws-ssl.conf  ${APACHE_CONF_DIR}/sites-available/sygal-import-ws-ssl.conf
#sed -i -re 's/SetEnv APPLICATION_ENV "(development|test)"/SetEnv APPLICATION_ENV "production"/' \
#    ${APACHE_CONF_DIR}/sites-available/sygal-import-ws-ssl.conf
a2ensite sygal-import-ws sygal-import-ws-ssl


###########################################################################################


#FROM apache AS bootstrap

# Nettoyage
#RUN apt-get autoremove -y && apt-get clean && rm -rf /tmp/* /var/tmp/*

# Copie les fichiers situés dans ./docker/entrypoint.d dans le dossier /entrypoint.d de l'image.
# Les scripts exécutables parmi eux seront exécutés au démarrage du container (cf. entrypoint.sh).
# Attention : les noms de fichiers ne doivent être constitués que de lettres minuscules ou majuscules,
# de chiffres, de tirets bas (underscore) ou de tirets ; extension interdite, donc.
#ADD docker/entrypoint.d/* /entrypoint.d/
## Copie des scripts complémentaires à lancer au démarrage du container.
#COPY docker/entrypoint.d/* /entrypoint.d/

# Entry point
#ADD docker/entrypoint.sh /sbin/entrypoint.sh
#RUN chmod 755 /sbin/entrypoint.sh
#CMD ["/sbin/entrypoint.sh"]
service php${PHP_VERSION}-fpm start
service apache2 restart


#COPY . /app

#WORKDIR /app

composer install --prefer-dist --optimize-autoloader --no-interaction

vendor/bin/laminas-development-mode disable
