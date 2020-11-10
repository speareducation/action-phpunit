#!/bin/sh
[ ! -f vendor/bin/phpunit ] && echo 'vendor/bin/phpunit not found' && exit 1

cp .env .env.bak 2>/dev/null
cp .env.github .env.testing
cp .env.github .env

composer dump-autoload # ensure fresh file paths since composer is run in another step

php artisan --env=testing migrate

if [ -z "$INPUT_TARGETDIR" ]
then
    outputFile=""
else
    [ ! -d "$INPUT_TARGETDIR" ] && mkdir "$INPUT_TARGETDIR"

    if [ -d storage ]
    then
        mkdir -p storage/logs
        ln -s $INPUT_TARGETDIR/logs storage/logs
    fi

    outputFile="$INPUT_TARGETDIR/phpunit-results.txt"
fi

vendor/bin/phpunit $INPUT_OPTIONS | tee $outputFile

exit $?