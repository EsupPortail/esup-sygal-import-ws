#!/usr/bin/env bash

#
# This script runs required operations in order to set up the application.
#

# Composer install
composer install --no-dev --no-suggest --optimize-autoloader
# NB: 'bin/generate-deploy-info-config.php' est lancé lors d'un composer install.

# Désactivation de l'interface d'admin Apigility
composer development-disable
