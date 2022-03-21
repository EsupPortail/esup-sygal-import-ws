#!/usr/bin/env bash

#
# This script runs required operations in order to set up the application.
#

# Composer install
composer install --no-dev --no-suggest --prefer-dist --optimize-autoloader

vendor/bin/doctrine-module orm:clear-cache:query
vendor/bin/doctrine-module orm:clear-cache:metadata
vendor/bin/doctrine-module orm:clear-cache:result
vendor/bin/doctrine-module orm:generate-proxies

# Désactivation de l'interface d'admin Apigility
composer development-disable
