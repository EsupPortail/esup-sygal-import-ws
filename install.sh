#!/usr/bin/env bash

#
# Script d'installation des pré-requis de l'application.
#
# Usages :
#   ./install.sh

set -o errexit

CURDIR=$(cd `dirname $0` && pwd)

cd ${CURDIR}

# Composer install
composer install --no-interaction --prefer-dist --optimize-autoloader

# Création ou vidange des répertoires de cache
mkdir -p data/cache && chmod 777 data/cache && rm -rf data/cache/*
mkdir -p data/DoctrineModule/cache && chmod 777 data/DoctrineModule/cache && rm -rf data/DoctrineModule/cache/*
mkdir -p data/DoctrineORMModule/Proxy && chmod 777 data/DoctrineORMModule/Proxy && rm -rf data/DoctrineORMModule/Proxy/*

vendor/bin/laminas-development-mode enable

vendor/bin/doctrine-module orm:generate-proxies
vendor/bin/doctrine-module orm:clear-cache:query
vendor/bin/doctrine-module orm:clear-cache:metadata
vendor/bin/doctrine-module orm:clear-cache:result

vendor/bin/laminas-development-mode disable
