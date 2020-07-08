#!/bin/sh
[ ! -f vendor/bin/phpunit ] && echo 'vendor/bin/phpunit not found' && exit 1

mkdir $INPUT_TARGETDIR

if [ -d storage ]
then
    mkdir -p storage/logs
    ln -s $INPUT_TARGETDIR/logs storage/logs
fi

cp .env .env.bak 2>/dev/null
cp .env.github .env.testing
cp .env.github .env

php artisan --env=testing migrate

vendor/bin/phpunit \
    --coverage-html=$INPUT_TARGETDIR/coverage-html \
    --coverage-text=$INPUT_TARGETDIR/coverage.txt |\
    tee $INPUT_TARGETDIR/phpunit-results.txt
