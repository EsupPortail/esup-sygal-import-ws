#!/usr/bin/env bash

#
# This script runs required operations in order to set up the application.
#

CURDIR=$(cd `dirname $0` && pwd)
cd ${CURDIR}

# Composer install
composer install --no-interaction --no-suggest --prefer-dist --optimize-autoloader

vendor/bin/doctrine-module orm:clear-cache:query
vendor/bin/doctrine-module orm:clear-cache:metadata
vendor/bin/doctrine-module orm:clear-cache:result
vendor/bin/doctrine-module orm:generate-proxies

composer development-disable
