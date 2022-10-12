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
composer install --no-interaction --no-suggest --prefer-dist --optimize-autoloader

vendor/bin/doctrine-module orm:clear-cache:query
vendor/bin/doctrine-module orm:clear-cache:metadata
vendor/bin/doctrine-module orm:clear-cache:result
vendor/bin/doctrine-module orm:generate-proxies

vendor/bin/laminas-development-mode disable

# Création ou vidange des répertoires de cache
mkdir -p data/cache && chmod -R 777 data/cache && rm -rf data/cache/*
mkdir -p data/DoctrineModule/cache && chmod -R 777 data/DoctrineModule/cache && rm -rf data/DoctrineModule/cache/*
