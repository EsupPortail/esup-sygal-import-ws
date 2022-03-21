#!/usr/bin/env bash

#
# This script runs required operations in order to set up the application.
#

# Composer install
composer install --no-dev --no-suggest --prefer-dist --optimize-autoloader

# Désactivation de l'interface d'admin Apigility
composer development-disable
