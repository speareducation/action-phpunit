#!/bin/sh
[ ! -f vendor/bin/phpunit ] && echo 'vendor/bin/phpunit not found' && exit 1

mkdir .test-results

if [ -d storage ]
then
    mkdir -p storage/logs
    ln -s .test-results/logs storage/logs
fi

cp .env .env.bak 2>/dev/null
cp .env.github .env.testing
cp .env.github .env

php artisan --env=testing migrate

vendor/bin/phpunit \
    --coverage-html=.test-results/coverage-html \
    --coverage-text=.test-results/coverage.txt |\
    tee .test-results/phpunit-results.txt